<?php

session_start();

header('Content-Type: application/json');

set_time_limit(180);
ini_set('memory_limit', '512M');

$debugLog =
    __DIR__ .
    '/remove_background_debug.log';

function tt_bg_log($message)
{
    global $debugLog;

    file_put_contents(
        $debugLog,
        '[' . date('Y-m-d H:i:s') . '] ' . $message . PHP_EOL,
        FILE_APPEND
    );
}

function tt_bg_json($data, $code = 200)
{
    http_response_code($code);

    echo json_encode(
        $data,
        JSON_UNESCAPED_SLASHES
    );

    exit;
}

tt_bg_log('Request started.');

if (!isset($_SESSION['user_id'])) {
    tt_bg_log('Blocked: not logged in.');

    tt_bg_json([
        'success' => false,
        'error' => 'Not logged in.'
    ], 403);
}

if (empty($_POST['image'])) {
    tt_bg_log(
        'Blocked: no image received. CONTENT_LENGTH=' .
        ($_SERVER['CONTENT_LENGTH'] ?? 'unknown') .
        ', post_max_size=' .
        ini_get('post_max_size')
    );

    tt_bg_json([
        'success' => false,
        'error' => 'No image received. The image may be too large for the server POST limit.'
    ], 400);
}

$imageData = $_POST['image'];

tt_bg_log(
    'Image field received. Length=' .
    strlen($imageData)
);

$imageData = preg_replace(
    '#^data:image/\w+;base64,#i',
    '',
    $imageData
);

$imageData = str_replace(
    ' ',
    '+',
    $imageData
);

$decoded = base64_decode($imageData, true);

if ($decoded === false || strlen($decoded) < 100) {
    tt_bg_log('Base64 decode failed or decoded image too small.');

    tt_bg_json([
        'success' => false,
        'error' => 'The image data could not be decoded.'
    ], 400);
}

$inputFile =
    sys_get_temp_dir() .
    '/tt_input_' .
    uniqid('', true) .
    '.png';

$outputFile =
    sys_get_temp_dir() .
    '/tt_output_' .
    uniqid('', true) .
    '.png';

if (file_put_contents($inputFile, $decoded) === false) {
    tt_bg_log('Could not write input temp file: ' . $inputFile);

    tt_bg_json([
        'success' => false,
        'error' => 'Could not write temporary input file.'
    ], 500);
}

tt_bg_log(
    'Input temp written: ' .
    $inputFile .
    ' size=' .
    filesize($inputFile)
);

$python =
    getenv('PYTHON_BIN') ?: 'python3';

$script =
__DIR__ . '/remove_background.py';

$command =
    escapeshellcmd($python) . ' ' .
    escapeshellarg($script) . ' ' .
    escapeshellarg($inputFile) . ' ' .
    escapeshellarg($outputFile) .
    ' 2>&1';

tt_bg_log('Running command: ' . $command);

$outputLines = [];
$exitCode = 0;

exec(
    $command,
    $outputLines,
    $exitCode
);

$commandOutput =
    trim(
        implode("\n", $outputLines)
    );

tt_bg_log('Command exit code: ' . $exitCode);

if ($commandOutput !== '') {
    tt_bg_log('Command output: ' . $commandOutput);
}

if (!file_exists($outputFile)) {
    if (file_exists($inputFile)) {
        unlink($inputFile);
    }

    tt_bg_log('Failed: output file was not created.');

    tt_bg_json([
        'success' => false,
        'error' =>
            'Background removal failed. Exit code: ' .
            $exitCode .
            ($commandOutput !== '' ? ' Output: ' . $commandOutput : ' No Python output was returned.')
    ], 500);
}

$outputSize = filesize($outputFile);

tt_bg_log(
    'Output temp created: ' .
    $outputFile .
    ' size=' .
    $outputSize
);

$outputData =
    file_get_contents($outputFile);

if (file_exists($inputFile)) {
    unlink($inputFile);
}

if (file_exists($outputFile)) {
    unlink($outputFile);
}

if ($outputData === false || strlen($outputData) < 100) {
    tt_bg_log('Failed: output image could not be read or was too small.');

    tt_bg_json([
        'success' => false,
        'error' => 'Background removal produced an invalid output image.'
    ], 500);
}

tt_bg_log('Success.');

tt_bg_json([
    'success' => true,
    'image' =>
        'data:image/png;base64,' .
        base64_encode($outputData)
]);
