<?php

$secret = getenv('TT_AUTH_SECRET') ?: '';

if ($secret !== '') {
    define('TT_AUTH_SECRET', $secret);
}
