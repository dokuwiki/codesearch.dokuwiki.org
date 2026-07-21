FROM opengrok/docker:1.14.3

RUN apt-get update && \
    apt-get install -y \
    php-cli \
    composer \
    git \
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
