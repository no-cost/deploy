<?php
$configPath = dirname(__FILE__) . '/../etc/config.json';
if (!file_exists($configPath)) {
    throw new RuntimeException("file not found: `{$configPath}`");
}

$jsonContent = file_get_contents($configPath);
if ($jsonContent === false) {
    throw new RuntimeException("failed to read: `{$configPath}`");
}

$config = json_decode($jsonContent, true, 512, JSON_THROW_ON_ERROR);
$defaults = [
    'offline' => false,
    'database' => [
        'host' => '127.0.0.1',
        'port' => '3306',
        'driver' => 'mysql',
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix' => '',
        'strict' => false,
    ],
    'paths' => [
        'api' => 'api',
        'admin' => 'admin',
    ],
];


$config = array_replace_recursive($defaults, $config);
return $config;
