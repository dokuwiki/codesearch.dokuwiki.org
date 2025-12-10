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

ENTRYPOINT ["/bin/sh", "-c", "wget https://raw.githubusercontent.com/dokuwiki/globalheader/refs/heads/main/globalheader.html -O /opengrok/data/footer_include && exec \"$@\"", "--"]
CMD ["/scripts/start.py"]
