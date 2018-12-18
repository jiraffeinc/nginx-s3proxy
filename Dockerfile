FROM debian:9-slim

ENV NGINX_VERSION=1.14.0

RUN apt-get -y update && \
    apt-get install -y \
        libpcre3 \
        libpcre3-dev \
        libxml2 \
        libxml2-dev \
        libxslt1-dev \
        python-dev \
        libgd-dev \
        libssl-dev \
        wget \
        gcc \
        make \
        git && \
    cd /usr/local/src && \
    wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" && \
    tar zvxf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    git clone https://github.com/anomalizer/ngx_aws_auth.git /usr/lib/nginx/modules/ngx_aws_auth && \
    ./configure --prefix=/usr/local/nginx-${NGINX_VERSION} \
        --with-debug \
        --with-pcre-jit \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_dav_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module \
        --with-http_v2_module \
        --with-http_sub_module \
        --with-http_xslt_module \
        --with-mail \
        --with-mail_ssl_module \
        --add-module=/usr/lib/nginx/modules/ngx_aws_auth \
        --with-ipv6 && \
    make install && \
    ln -sf /usr/local/nginx-${NGINX_VERSION} /usr/local/nginx && \
    mkdir -p /var/cache/nginx && \
    apt-get purge -y git && \
    apt-get autoremove -y && \
    mkdir -p /data/cache
