#!/usr/bin/env php
<?php

require 'vendor/autoload.php';

$cli = new \dokuwiki\codesearch\Downloader();
$cli->run();
