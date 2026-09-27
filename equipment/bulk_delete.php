<?php

session_start();

require_once '../config/database.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: ../login.php');
    exit;
}

$bulkDelete =
    $_SESSION['equipment_bulk_delete']
    ?? null;

if (
    !is_array($bulkDelete)
    || empty($bulkDelete['ids'])
) {
    header('Location: list.php?bulk_message=none_selected');
    exit;
}

$returnUrl =
    $bulkDelete['return_url']
    ?? 'list.php';

if (
    !is_string($returnUrl)
    || $returnUrl === ''
    || preg_match('#^(?:https?:)?//#i', $returnUrl)
    || strpos($returnUrl, "\n") !== false
    || strpos($returnUrl, "\r") !== false
) {
    $returnUrl = 'list.php';
}

function tt_bulk_delete_return_url($returnUrl, $message = '')
{
    if ($message === '') {
        return $returnUrl;
    }

    $separator =
        strpos($returnUrl, '?') === false
        ? '?'
        : '&';

    return
        $returnUrl
        . $separator
        . 'bulk_message='
        . rawurlencode($message);
}

$ids =
    array_values(
        array_filter(
            array_unique(
                array_map(
                    'intval',
                    (array)$bulkDelete['ids']
                )
            ),
            fn($id) => $id > 0
        )
    );

if (!$ids) {
    unset($_SESSION['equipment_bulk_delete']);
    header('Location: ' . tt_bulk_delete_return_url($returnUrl, 'none_selected'));
    exit;
}

$placeholders =
    implode(
        ',',
        array_fill(
            0,
            count($ids),
            '?'
        )
    );

$stmt = $pdo->prepare("
    SELECT e.*
    FROM equipment e
    JOIN railroads r
        ON e.railroad_id = r.id
    WHERE r.user_id = ?
    AND e.id IN ($placeholders)
    ORDER BY e.reporting_marks, e.road_number
");

$stmt->execute(
    array_merge(
        [$_SESSION['user_id']],
        $ids
    )
);

$equipmentList =
    $stmt->fetchAll(PDO::FETCH_ASSOC);

if (!$equipmentList) {
    unset($_SESSION['equipment_bulk_delete']);
    header('Location: ' . tt_bulk_delete_return_url($returnUrl, 'none_authorized'));
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if (
        ($_POST['confirm_delete'] ?? '') !== '1'
    ) {
        unset($_SESSION['equipment_bulk_delete']);
        header('Location: ' . $returnUrl);
        exit;
    }

    $deleteIds =
        array_map(
            'intval',
            array_column(
                $equipmentList,
                'id'
            )
        );

    $deletePlaceholders =
        implode(
            ',',
            array_fill(
                0,
                count($deleteIds),
                '?'
            )
        );

    foreach ($equipmentList as $equipment) {

        if (!empty($equipment['photo_filename'])) {

            $photoPath =
                dirname(__DIR__) .
                '/uploads/' .
                $equipment['photo_filename'];

            if (is_file($photoPath)) {
                unlink($photoPath);
            }

        }

    }

    $deleteStmt = $pdo->prepare("
        DELETE e
        FROM equipment e
        JOIN railroads r
            ON e.railroad_id = r.id
        WHERE r.user_id = ?
        AND e.id IN ($deletePlaceholders)
    ");

    $deleteStmt->execute(
        array_merge(
            [$_SESSION['user_id']],
            $deleteIds
        )
    );

    unset($_SESSION['equipment_bulk_delete']);

    header('Location: ' . tt_bulk_delete_return_url($returnUrl, 'deleted'));
    exit;

}

?>

<?php include '../includes/header.php'; ?>

<title>Delete Selected Equipment</title>

</head>

<body>

<?php include '../includes/navbar.php'; ?>

<div class="container mt-5">

<div class="card">

<div class="card-header bg-danger text-white">
Delete Selected Equipment
</div>

<div class="card-body">

<p class="lead">
Please confirm that you want to delete the following equipment.
</p>

<p class="text-muted">
This action cannot be undone.
</p>

<div class="table-responsive mb-4">

<table class="table table-sm table-striped align-middle">

<thead>
<tr>
<th>Reporting Marks</th>
<th>Road Number</th>
<th>Road Name</th>
</tr>
</thead>

<tbody>

<?php foreach ($equipmentList as $equipment): ?>

<tr>
<td><?php echo htmlspecialchars($equipment['reporting_marks']); ?></td>
<td><?php echo htmlspecialchars($equipment['road_number']); ?></td>
<td><?php echo htmlspecialchars($equipment['road_name']); ?></td>
</tr>

<?php endforeach; ?>

</tbody>

</table>

</div>

<form method="post">

<input type="hidden" name="confirm_delete" value="1">

<button type="submit" class="btn btn-danger me-2">
Yes, Delete Selected
</button>

<a href="<?php echo htmlspecialchars($returnUrl, ENT_QUOTES, 'UTF-8'); ?>" class="btn btn-secondary">
Cancel
</a>

</form>

</div>

</div>

</div>

<?php include '../includes/footer.php'; ?>
