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
    tar zxf nginx-${NGINX_VERSION}.tar.gz && \
    mv nginx-${NGINX_VERSION} nginx && \
    cd nginx && \
    git clone -b 2.1.1 https://github.com/anomalizer/ngx_aws_auth.git /usr/lib/nginx/modules/ngx_aws_auth && \
    ./configure --prefix=/usr/local/nginx \
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
    ln -sf /usr/local/nginx/sbin/nginx /usr/local/bin/nginx && \
    ln -sf /dev/stdout /usr/local/nginx/logs/access.log && \
    ln -sf /dev/stderr /usr/local/nginx/logs/error.log

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-c", "/usr/local/nginx/conf/nginx.conf", "-g", "daemon off;"]
