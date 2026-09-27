<?php

if (PHP_SAPI !== 'cli') {
    http_response_code(404);
    exit;
}

require_once __DIR__ . '/../config/database.php';

function ttDemoCleanupHasColumn(PDO $pdo, string $table, string $column): bool
{
    static $cache = [];
    $key = $table . '.' . $column;
    if (isset($cache[$key])) {
        return $cache[$key];
    }

    $stmt = $pdo->prepare(
        'SELECT 1 FROM information_schema.columns '
        . 'WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ? LIMIT 1'
    );
    $stmt->execute([$table, $column]);
    return $cache[$key] = (bool)$stmt->fetchColumn();
}

function ttDemoCleanupDeleteIn(PDO $pdo, string $table, string $column, array $ids): int
{
    if (!$ids || !preg_match('/^[a-z_]+$/i', $table) || !preg_match('/^[a-z_]+$/i', $column)) {
        return 0;
    }
    if (!ttDemoCleanupHasColumn($pdo, $table, $column)) {
        return 0;
    }

    $marks = implode(',', array_fill(0, count($ids), '?'));
    $stmt = $pdo->prepare("DELETE FROM `{$table}` WHERE `{$column}` IN ({$marks})");
    $stmt->execute(array_values($ids));
    return $stmt->rowCount();
}

function ttDemoCleanupOwnedFiles(PDO $pdo, array $filenames, string $uploadsDirectory): int
{
    if (!$filenames || !is_dir($uploadsDirectory)) {
        return 0;
    }

    $root = realpath($uploadsDirectory);
    if ($root === false) {
        return 0;
    }

    $removed = 0;
    foreach (array_unique($filenames) as $filename) {
        if (!is_string($filename) || $filename === '' || basename($filename) !== $filename) {
            continue;
        }

        $stillUsed = false;
        foreach (['equipment', 'industries'] as $table) {
            foreach (['photo_filename', 'cutout_filename'] as $column) {
                if (!ttDemoCleanupHasColumn($pdo, $table, $column)) {
                    continue;
                }
                $stmt = $pdo->prepare("SELECT 1 FROM `{$table}` WHERE `{$column}` = ? LIMIT 1");
                $stmt->execute([$filename]);
                if ($stmt->fetchColumn()) {
                    $stillUsed = true;
                    break 2;
                }
            }
        }
        if ($stillUsed) {
            continue;
        }

        $path = realpath($root . DIRECTORY_SEPARATOR . $filename);
        if ($path !== false && dirname($path) === $root && is_file($path) && unlink($path)) {
            $removed++;
        }
    }
    return $removed;
}

if (
    !ttDemoCleanupHasColumn($pdo, 'users', 'demo_user')
    || !ttDemoCleanupHasColumn($pdo, 'users', 'expires_at')
) {
    fwrite(STDERR, "Demo cleanup skipped: users.demo_user and users.expires_at are required.\n");
    exit(1);
}

$expiredStmt = $pdo->query(
    'SELECT id FROM users WHERE demo_user = 1 AND expires_at IS NOT NULL AND expires_at <= UTC_TIMESTAMP()'
);
$expiredUserIds = array_map('intval', $expiredStmt->fetchAll(PDO::FETCH_COLUMN));
$removedUsers = 0;
$removedFiles = 0;

foreach ($expiredUserIds as $userId) {
    $railroadStmt = $pdo->prepare('SELECT id FROM railroads WHERE user_id = ?');
    $railroadStmt->execute([$userId]);
    $railroadIds = array_map('intval', $railroadStmt->fetchAll(PDO::FETCH_COLUMN));
    $filenames = [];

    if ($railroadIds) {
        foreach (['equipment', 'industries'] as $table) {
            if (!ttDemoCleanupHasColumn($pdo, $table, 'railroad_id')) {
                continue;
            }
            foreach (['photo_filename', 'cutout_filename'] as $column) {
                if (!ttDemoCleanupHasColumn($pdo, $table, $column)) {
                    continue;
                }
                $marks = implode(',', array_fill(0, count($railroadIds), '?'));
                $stmt = $pdo->prepare("SELECT `{$column}` FROM `{$table}` WHERE railroad_id IN ({$marks}) AND `{$column}` IS NOT NULL AND `{$column}` <> ''");
                $stmt->execute($railroadIds);
                array_push($filenames, ...$stmt->fetchAll(PDO::FETCH_COLUMN));
            }
        }
    }

    $pdo->beginTransaction();
    try {
        if ($railroadIds) {
            // Remove tables that hold restrictive references before their parent rows.
            foreach ([
                'operation_yard_history',
                'operation_yard_assignments',
                'operation_session_roles',
                'operation_switch_list_moves',
                'operation_switch_lists',
                'operation_switch_moves',
                'operation_switch_sessions',
                'operation_session_invites',
                'operation_repair_history',
                'operation_repairs',
                'repair_queue',
                'waybills',
                'operation_log',
                'operation_railroad_roles',
                'operation_module_settings',
                'operations_service_options',
            ] as $table) {
                ttDemoCleanupDeleteIn($pdo, $table, 'railroad_id', $railroadIds);
            }

            // Clear self-references and dependent session data before deleting sessions.
            $marks = implode(',', array_fill(0, count($railroadIds), '?'));
            if (ttDemoCleanupHasColumn($pdo, 'operation_assignments', 'predecessor_assignment_id')) {
                $stmt = $pdo->prepare("UPDATE operation_assignments SET predecessor_assignment_id = NULL WHERE railroad_id IN ({$marks})");
                $stmt->execute($railroadIds);
            }
            ttDemoCleanupDeleteIn($pdo, 'operation_assignments', 'railroad_id', $railroadIds);
            ttDemoCleanupDeleteIn($pdo, 'operating_sessions', 'railroad_id', $railroadIds);

            // Job detail tables have no railroad_id in older schemas, so scope them through owned jobs.
            $jobIds = [];
            if (ttDemoCleanupHasColumn($pdo, 'jobs', 'railroad_id')) {
                $stmt = $pdo->prepare("SELECT id FROM jobs WHERE railroad_id IN ({$marks})");
                $stmt->execute($railroadIds);
                $jobIds = array_map('intval', $stmt->fetchAll(PDO::FETCH_COLUMN));
            }
            foreach (['job_cars', 'job_industries', 'job_locomotives', 'job_operation_profiles', 'job_route_stops'] as $table) {
                ttDemoCleanupDeleteIn($pdo, $table, 'job_id', $jobIds);
                ttDemoCleanupDeleteIn($pdo, $table, 'railroad_id', $railroadIds);
            }
            ttDemoCleanupDeleteIn($pdo, 'prepared_cuts', 'railroad_id', $railroadIds);
            ttDemoCleanupDeleteIn($pdo, 'jobs', 'railroad_id', $railroadIds);
            ttDemoCleanupDeleteIn($pdo, 'industries', 'railroad_id', $railroadIds);
            ttDemoCleanupDeleteIn($pdo, 'equipment', 'railroad_id', $railroadIds);
        }

        ttDemoCleanupDeleteIn($pdo, 'operation_railroad_roles', 'user_id', [$userId]);
        ttDemoCleanupDeleteIn($pdo, 'user_settings', 'user_id', [$userId]);
        ttDemoCleanupDeleteIn($pdo, 'auth_remember_tokens', 'user_id', [$userId]);
        ttDemoCleanupDeleteIn($pdo, 'users', 'id', [$userId]);
        $pdo->commit();

        $removedUsers++;
        $removedFiles += ttDemoCleanupOwnedFiles($pdo, $filenames, __DIR__ . '/../uploads');
    } catch (Throwable $exception) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        fwrite(STDERR, "Demo cleanup failed for user {$userId}: {$exception->getMessage()}\n");
        exit(1);
    }
}

// Scanned images not saved into equipment records have no database owner. Retain them for a day.
$tempDirectory = __DIR__ . '/../uploads/temp';
if (is_dir($tempDirectory)) {
    $cutoff = time() - 24 * 60 * 60;
    foreach (new DirectoryIterator($tempDirectory) as $entry) {
        if ($entry->isFile() && !$entry->isDot() && $entry->getMTime() < $cutoff && unlink($entry->getPathname())) {
            $removedFiles++;
        }
    }
}

fwrite(STDOUT, "Expired demo accounts removed: {$removedUsers}; unreferenced upload files removed: {$removedFiles}.\n");
