# DokuWiki CodeSearch

The CodeSearch service is powerd by [OpenGrok](https://opengrok.github.io/OpenGrok/), an open source source code search and cross reference engine. A PHP script (see below) uses the DokuWiki plugin repository API to periodically download all available DokuWiki plugins and templates, and indexes them with OpenGrok.

The service is hosted at https://codesearch.dokuwiki.org/ and is open to everyone.

## DokuWiki Extension Mirror Script

This tool will download all available DokuWiki plugins/templates and extract them to `data/src`. This is useful for DokuWiki developers who need to check if a certain DokuWiki function is used by any plugins.

It's also helpful to figure out which extensions are no longer downloadable. An error log is placed into `./data/meta/error.log`.

Downloaded archives are kept in `data/meta` when extraction fails to ease debugging.

The tool uses the DokuWiki [plugin repository API](https://github.com/splitbrain/dokuwiki-plugin-pluginrepo/blob/master/README-API) and will only download a plugin again when it's version changes.

### Setup

Just use composer:

    composer install

### Running

Call the mainfile:

    ./extensionmirror.php

Optionally, specify where to put the data:

    ./extensionmirror.php -d /path/to/data

You can also download the current `master` of DokuWiki itself (in addition to all extensions) using the `-w` option:

    ./extensionmirror.php -w

