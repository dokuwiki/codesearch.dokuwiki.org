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

## Deployment

The whole service (OpenGrok together with the mirror script) runs as a single Docker container managed through `docker compose`. All persistent data is kept in bind-mounted directories below `./volumes`:

- `./volumes/data` is mounted as `/data` and holds the downloaded extensions and the mirror's metadata. Its `src` subdirectory is additionally mounted as OpenGrok's source root.
- `./volumes/index` is mounted as `/opengrok/data` and holds the OpenGrok search index.
- `./volumes/config` is mounted as `/opengrok/etc` and holds the OpenGrok configuration.

The container runs as a non-root user (`user: "1000:0"` in `docker-compose.yml`). Docker creates missing bind-mount directories as `root`, which that user could not write to, so the directories have to be created and owned by the container's UID before the first start:

    mkdir -p volumes/data/src volumes/index volumes/config
    chown -R 1000:0 volumes

The UID must match the one configured in `docker-compose.yml` and exist on the host; the group has to stay `0`. Afterwards build and start the service:

    docker compose up -d --build

The web interface is then available at http://localhost:2015/.

