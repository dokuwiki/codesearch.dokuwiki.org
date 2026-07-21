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

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/scripts/start.py"]
