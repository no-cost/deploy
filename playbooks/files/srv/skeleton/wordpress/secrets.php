<?php
$main_domain = "{{ main_domain }}";

define('AUTH_KEY',         "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
define('SECURE_AUTH_KEY',  "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
define('LOGGED_IN_KEY',    "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
define('NONCE_KEY',        "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
define('AUTH_SALT',        "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
define('SECURE_AUTH_SALT', "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
define('LOGGED_IN_SALT',   "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
define('NONCE_SALT',       "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}");
