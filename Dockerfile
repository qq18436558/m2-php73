FROM ubuntu:20.04

ENV LANG C.UTF-8

RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get install -y wget tzdata cron && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64.tar.gz -O /tmp/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin && \
    apt -y install software-properties-common && add-apt-repository -y ppa:ondrej/php && apt update && \
    apt -y install php7.3 php7.3-cli php7.3-bcmath php7.3-bz2 php7.3-dom php7.3-sqlite3 php7.3-xml php7.3-xmlrpc php7.3-xsl php7.3-common php7.3-curl php7.3-fpm php7.3-gd php7.3-imagick php7.3-imap php7.3-intl php7.3-json php7.3-mbstring php7.3-mcrypt php7.3-mysql php7.3-opcache php7.3-redis php7.3-soap php7.3-zip && \
    sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT/error_reporting = E_ALL \& \~E_NOTICE/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/post_max_size = 8M/post_max_size = 50M/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/max_file_uploads = 20/max_file_uploads = 200/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/;date.timezone =/date.timezone = PRC/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/session.gc_probability = 0/session.gc_probability = 1/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/;curl.cainfo =/curl.cainfo = \/etc\/pki\/tls\/certs\/ca-bundle.crt/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/;openssl.cafile=/openssl.cafile=\/etc\/pki\/tls\/certs\/ca-bundle.crt/g" /etc/php/7.3/cli/php.ini && \
    sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/memory_limit = 128M/memory_limit = 2G/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/max_input_time = 60/max_input_time = 3600/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/;max_input_vars = 1000/max_input_vars = 200000/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT/error_reporting = E_ALL \& \~E_NOTICE/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/post_max_size = 8M/post_max_size = 50M/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/max_file_uploads = 20/max_file_uploads = 200/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/;date.timezone =/date.timezone = PRC/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/session.gc_probability = 0/session.gc_probability = 1/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/;curl.cainfo =/curl.cainfo = \/etc\/pki\/tls\/certs\/ca-bundle.crt/g" /etc/php/7.3/fpm/php.ini && \
    sed -i -e "s/;openssl.cafile=/openssl.cafile=\/etc\/pki\/tls\/certs\/ca-bundle.crt/g" /etc/php/7.3/fpm/php.ini && \
    mkdir -p /run/php /logs /etc/pki/tls/certs/ && apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000

COPY cacert.pem /etc/pki/tls/certs/ca-bundle.crt
COPY php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
