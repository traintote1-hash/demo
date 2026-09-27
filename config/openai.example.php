<?php

$OPENAI_API_KEY = getenv('OPENAI_API_KEY') ?: '';

if ($OPENAI_API_KEY === '') {
    throw new RuntimeException('Set OPENAI_API_KEY in the server environment to use AI equipment scanning.');
}
