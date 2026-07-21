FROM opengrok/docker:1.14.15

# The base image ships Perforce (p4) plus its apt repository. The repository's
# signing key is missing, which breaks apt-get update, and OpenGrok probes
# every source directory with p4 even though all mirrored sources are git or
# zip. The repository is removed so apt works, and the Perforce packages are
# purged; only php, composer and git are needed. Purging leaves /opt/perforce
# behind (it holds files not owned by the packages), so it is removed too.
RUN rm -f /etc/apt/sources.list.d/perforce.list && \
    apt-get update && \
    apt-get install -y \
    php-cli \
    composer \
    git \
    && apt-get purge -y '^p4-.*' '^helix-.*' \
    && apt-get autoremove -y \
    && rm -rf /opt/perforce \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./ /app/
RUN cd /app && composer install --no-dev --optimize-autoloader

# Allow running as an arbitrary non-root UID (configured via `user:` in
# docker-compose.yml). Such a UID always joins group 0, and OpenGrok's
# start.py rewrites the Tomcat webapps directory on every startup, so the
# whole Tomcat tree is made writable for that group.
RUN chgrp -R 0 /usr/local/tomcat && \
    chmod -R g=u /usr/local/tomcat

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/scripts/start.py"]
