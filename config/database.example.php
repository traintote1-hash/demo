<?php

$host = getenv('DB_HOST') ?: 'localhost';
$dbname = getenv('DB_NAME') ?: '';
$username = getenv('DB_USER') ?: '';
$password = getenv('DB_PASSWORD') ?: '';

if ($dbname === '' || $username === '') {
    throw new RuntimeException('Set DB_NAME and DB_USER in the server environment.');
}

$pdo = new PDO(
    "mysql:host={$host};dbname={$dbname};charset=utf8mb4",
    $username,
    $password,
    [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]
);
