<?php

session_start();

require_once '../config/database.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: ../login.php');
    exit;
}

function tt_edit_queue_default_return()
{
    return 'list.php';
}

function tt_edit_queue_return_url($queue)
{
    $returnUrl =
        $queue['return_url']
        ?? tt_edit_queue_default_return();

    if (
        !is_string($returnUrl)
        || $returnUrl === ''
        || preg_match('#^(?:https?:)?//#i', $returnUrl)
        || strpos($returnUrl, "\n") !== false
        || strpos($returnUrl, "\r") !== false
    ) {
        return tt_edit_queue_default_return();
    }

    return $returnUrl;
}

function tt_edit_queue_finish($queue)
{
    $returnUrl =
        tt_edit_queue_return_url($queue);

    unset($_SESSION['equipment_edit_queue']);

    $separator =
        strpos($returnUrl, '?') === false
        ? '?'
        : '&';

    header(
        'Location: ' .
        $returnUrl .
        $separator .
        'bulk_message=queue_finished'
    );

    exit;
}

$queue =
    $_SESSION['equipment_edit_queue']
    ?? [
        'ids' => [],
        'position' => 0,
        'return_url' => tt_edit_queue_default_return(),
    ];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $queueAction =
        $_POST['queue_action']
        ?? '';

    if ($queueAction === 'finish') {
        tt_edit_queue_finish($queue);
    }

    if ($queueAction === 'remove') {

        $removeId =
            (int)(
                $_POST['equipment_id']
                ?? 0
            );

        $queue['ids'] =
            array_values(
                array_filter(
                    array_map(
                        'intval',
                        (array)(
                            $queue['ids']
                            ?? []
                        )
                    ),
                    fn($id) => $id > 0 && $id !== $removeId
                )
            );

        $queue['position'] =
            min(
                (int)(
                    $queue['position']
                    ?? 0
                ),
                max(
                    0,
                    count($queue['ids']) - 1
                )
            );

        $_SESSION['equipment_edit_queue'] =
            $queue;

        header('Location: edit_queue.php');
        exit;

    }

}

$ids =
    array_values(
        array_filter(
            array_unique(
                array_map(
                    'intval',
                    (array)(
                        $queue['ids']
                        ?? []
                    )
                )
            ),
            fn($id) => $id > 0
        )
    );

if (!$ids) {
    unset($_SESSION['equipment_edit_queue']);
    header('Location: list.php?bulk_message=queue_empty');
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
");

$stmt->execute(
    array_merge(
        [$_SESSION['user_id']],
        $ids
    )
);

$rowsById = [];

foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
    $rowsById[(int)$row['id']] = $row;
}

$validIds = [];
$equipmentList = [];

foreach ($ids as $id) {

    if (isset($rowsById[$id])) {
        $validIds[] = $id;
        $equipmentList[] = $rowsById[$id];
    }

}

if (!$validIds) {
    unset($_SESSION['equipment_edit_queue']);
    header('Location: list.php?bulk_message=queue_empty');
    exit;
}

$position =
    (int)(
        $queue['position']
        ?? 0
    );

$position =
    max(
        0,
        min(
            $position,
            count($validIds) - 1
        )
    );

$_SESSION['equipment_edit_queue'] = [
    'ids' => $validIds,
    'position' => $position,
    'return_url' => tt_edit_queue_return_url($queue),
];

$currentId =
    $validIds[$position]
    ?? $validIds[0];

$hasStarted =
    $position > 0;

?>

<?php include '../includes/header.php'; ?>

<title>Bulk Edit Queue</title>

</head>

<body>

<?php include '../includes/navbar.php'; ?>

<div class="container mt-4 mb-5">

<div class="d-flex justify-content-between align-items-start mb-4">

<div>
<h1 class="mb-1">Bulk Edit Queue</h1>
<div class="text-muted">
<?php echo count($validIds); ?> selected equipment records
</div>
</div>

<div class="d-flex gap-2">

<a
href="edit.php?id=<?php echo (int)$currentId; ?>&queue=1"
class="btn btn-primary">
<?php echo $hasStarted ? 'Continue Editing' : 'Start Editing'; ?>
</a>

<form method="post">
<input type="hidden" name="queue_action" value="finish">
<button type="submit" class="btn btn-secondary">
Finish
</button>
</form>

</div>

</div>

<div class="card">

<div class="card-body p-0">

<div class="table-responsive">

<table class="table table-hover align-middle mb-0">

<thead>
<tr>
<th style="width:80px;">Photo</th>
<th>Equipment</th>
<th>Road Name</th>
<th>Class</th>
<th>Type</th>
<th>Status</th>
<th>Queue</th>
<th></th>
</tr>
</thead>

<tbody>

<?php foreach ($equipmentList as $index => $equipment): ?>

<?php
$isCurrent =
    $index === $position;

$statusLabel =
    $index < $position
    ? 'Completed'
    : (
        $isCurrent
        ? 'Current'
        : 'Pending'
    );

$statusClass =
    $index < $position
    ? 'bg-success'
    : (
        $isCurrent
        ? 'bg-primary'
        : 'bg-secondary'
    );
?>

<tr>
<td>
<?php if (!empty($equipment['photo_filename'])): ?>
<img
src="../uploads/<?php echo htmlspecialchars($equipment['photo_filename']); ?>"
class="img-thumbnail"
style="max-width:64px;max-height:48px;">
<?php endif; ?>
</td>
<td>
<strong>
<?php echo htmlspecialchars(trim($equipment['reporting_marks'] . ' ' . $equipment['road_number'])); ?>
</strong>
<div class="small text-muted">
<?php echo htmlspecialchars($equipment['manufacturer'] ?? ''); ?>
</div>
</td>
<td><?php echo htmlspecialchars($equipment['road_name'] ?? ''); ?></td>
<td><?php echo htmlspecialchars($equipment['equipment_class'] ?? ''); ?></td>
<td><?php echo htmlspecialchars($equipment['equipment_type'] ?? ''); ?></td>
<td>
<?php if (!empty($equipment['active'])): ?>
<span class="badge bg-success">Active</span>
<?php else: ?>
<span class="badge bg-secondary">Inactive</span>
<?php endif; ?>
</td>
<td>
<span class="badge <?php echo $statusClass; ?>">
<?php echo $statusLabel; ?>
</span>
<div class="small text-muted">
<?php echo $index + 1; ?> of <?php echo count($validIds); ?>
</div>
</td>
<td class="text-end">
<a
href="edit.php?id=<?php echo (int)$equipment['id']; ?>&queue=1"
class="btn btn-sm btn-outline-primary">
Edit
</a>
<form method="post" class="d-inline">
<input type="hidden" name="queue_action" value="remove">
<input type="hidden" name="equipment_id" value="<?php echo (int)$equipment['id']; ?>">
<button type="submit" class="btn btn-sm btn-outline-danger">
Remove from Queue
</button>
</form>
</td>
</tr>

<?php endforeach; ?>

</tbody>

</table>

</div>

</div>

</div>

</div>

<?php include '../includes/footer.php'; ?>
