#!/bin/sh
set -e

# Fetch the shared DokuWiki global header used as the OpenGrok footer.
wget https://raw.githubusercontent.com/dokuwiki/globalheader/refs/heads/main/globalheader.html \
    -O /opengrok/data/footer_include

# Mirror all extensions in the background: once immediately on (re)start, then
# again every day shortly after midnight. Running in the background keeps this
# from delaying the OpenGrok startup below. A single failed run must not stop
# the schedule, so error handling is relaxed inside the loop.
(
    set +e
    while true; do
        echo "[mirror] starting extension sync"
        (cd /app && ./extensionmirror.php -d /data -w -g) || echo "[mirror] extension sync failed"

        now=$(date +%s)
        next=$(date -d 'tomorrow 00:00' +%s)
        sleep "$((next - now))"
    done
) &

# Hand over to the container's main command (OpenGrok).
exec "$@"
