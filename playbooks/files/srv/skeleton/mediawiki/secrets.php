<?php
$mainDomain = "{{ main_domain }}";
$wgSecretKey = "{{ lookup('password', '/dev/null chars=hexdigits length=32') }}";
