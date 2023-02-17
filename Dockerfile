FROM nginx:latest

LABEL   Maintainer="I Made Ocy Darma Putra <ochi@troke.id>" \
        Description="Docker, nginx and php"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common curl wget gnupg2 ca-certificates lsb-release apt-transport-https

RUN wget https://packages.sury.org/php/apt.gpg
RUN apt-key add apt.gpg

RUN echo '"deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php7.list'

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    curl \
    git \
    jhead \
    php7.4-common \
    php7.4-curl \
    php7.4-ds \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-tokenizer \
    php7.4-xml \
    php7.4-zip \
    php7.4 \
    zip

# MOVE ROOT FOLDER
WORKDIR /app

COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/sites.conf /etc/nginx/conf.d/default.conf

RUN rm -f /var/log/nginx/access.log /var/log/nginx/error.log && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY . /app

EXPOSE 80/tcp

CMD ["nginx", "-g", "daemon off;"]