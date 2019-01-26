FROM alpine:3.8

LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"

ENV NGINX_VERSION 1.15.8
ENV GEOIP_VERSION 1.6.12
ENV GEOIP_BASE_URL      https://geolite.maxmind.com/download/geoip/database
ENV GEOIP_CNTR_DB       GeoLite2-Country.mmdb
ENV GEOIP_CITY_DB       GeoLite2-City.mmdb
ENV GEOIP_DB_DIR        /usr/local/share/GeoIP
# ENV LD_LIBRARY_PATH 	/usr/local/lib
WORKDIR /tmp

RUN build_packages="wget build-base ca-certificates linux-headers openssl-dev pcre-dev zlib-dev" \
&& runtime_packages="openssl pcre zlib" \
&& apk --update add ${build_packages} ${runtime_packages} \
&& apk add --update --no-cache wget build-base ca-certificates \
&& cd /tmp \ 
&& apk update && apk upgrade \
&& apk add --no-cache bash git openssh libmaxminddb-dev \
# install GeoIP:
&& wget https://github.com/maxmind/geoip-api-c/releases/download/v${GEOIP_VERSION}/GeoIP-${GEOIP_VERSION}.tar.gz \
&& tar -zxvf GeoIP-${GEOIP_VERSION}.tar.gz \
&& cd GeoIP-${GEOIP_VERSION} \
&& ./configure \
&& make \
&& make check \
&& make install

# get GeoIP.dat database
ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz ${GEOIP_CNTR_DB}.tar.gz
ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz ${GEOIP_CITY_DB}.tar.gz
RUN mkdir -p ${GEOIP_DB_DIR} \
&& gunzip -c -v /tmp/${GEOIP_CNTR_DB}.tar.gz > ${GEOIP_DB_DIR}/${GEOIP_CNTR_DB} \
&& gunzip -c -v /tmp/${GEOIP_CITY_DB}.tar.gz > ${GEOIP_DB_DIR}/${GEOIP_CITY_DB} \
&& cd /usr/local/share/GeoIP/ \
&& ls -l \
&& rm -f /tmp/GeoLite2-* \
&& cd ~

ENV LD_RUN_PATH=/usr/local/lib
ENV LD_LIBRARY_PATH=/usr/local/lib/
RUN git clone https://github.com/leev/ngx_http_geoip2_module.git
VOLUME ${GEOIP_DB_DIR}
WORKDIR /nginx
# RUN mkdir nginx
# install nginx:

RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
	&& CONFIG="\
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
		--add-dynamic-module=/tmp/ngx_http_geoip2_module \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-http_xslt_module=dynamic \
		--with-http_image_filter_module=dynamic \
		--with-http_geoip_module=dynamic \
		--with-http_perl_module=dynamic \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-stream_realip_module \
		--with-stream_geoip_module=dynamic \
		--with-http_slice_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-compat \
		--with-file-aio \
    		--with-ipv6 \
		--with-http_v2_module \
	" \
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		openssl-dev \
		pcre-dev \
		zlib-dev \
		linux-headers \
		curl \
		gnupg1 \
		libxslt-dev \
		gd-dev \
		geoip-dev \
		perl-dev \
	&& curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
	&& curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx.tar.gz.asc \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& found=''; \
	for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
		hkp://p80.pool.sks-keyservers.net:80 \
		pgp.mit.edu \
	; do \
		echo "Fetching GPG key $GPG_KEYS from $server"; \
		gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$GPG_KEYS" && found=yes && break; \
	done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEYS" && exit 1; \
	gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz \
	&& rm -rf "$GNUPGHOME" nginx.tar.gz.asc \
	&& mkdir -p /usr/src \
	&& tar -zxC /usr/src -f nginx.tar.gz \
	&& rm nginx.tar.gz \
	&& cd /usr/src/nginx-$NGINX_VERSION \
	&& ./configure $CONFIG --with-debug \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& mv objs/nginx objs/nginx-debug \
	&& mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
	&& mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
	&& mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
	&& mv objs/ngx_http_perl_module.so objs/ngx_http_perl_module-debug.so \
	&& mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
	&& ./configure $CONFIG \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& mkdir -p /usr/share/nginx/html/ \
	&& install -m644 html/index.html /usr/share/nginx/html/ \
	&& install -m644 html/50x.html /usr/share/nginx/html/ \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
	&& install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
	&& install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
	&& install -m755 objs/ngx_http_perl_module-debug.so /usr/lib/nginx/modules/ngx_http_perl_module-debug.so \
	&& install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
	&& ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so \
	&& rm -rf /usr/src/nginx-$NGINX_VERSION \
	\
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --no-cache --virtual .nginx-rundeps $runDeps \
	&& apk del .build-deps \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/local/bin/ \
        && rm /usr/local/lib/libGeoIP.a \
        && rm -rf /tmp/src \
        && rm -rf /var/cache/apk/* \
	# Bring in tzdata so users could set the timezones through the environment
	# variables
	&& apk add --no-cache tzdata \
	\
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log


ENV RAILS_ROOT /var/www/movierecommendationswithml
# Set our working directory inside the image
WORKDIR $RAILS_ROOT
# where we store everything SSL-related
ENV SSL_ROOT /var/www/ssl

# where Nginx looks for SSL files
ENV SSL_CERT_HOME $SSL_ROOT/certs/live
# create log directory
RUN mkdir log
# copy over static assets
COPY public public/
# Copy Nginx config template
COPY ./docker/web/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/web/conf.d/nginx_server.conf /etc/nginx/conf.d/default.conf
COPY ./docker/web/conf.d/botblocker-nginx-settings.conf  /etc/nginx/conf.d/botblocker-nginx-settings.conf
COPY ./docker/web/conf.d/drop.lasso.conf  /etc/nginx/conf.d/drop.lasso.conf
COPY ./docker/web/conf.d/globalblacklist.conf  /etc/nginx/conf.d/globalblacklist.conf
COPY ./docker/web/user_agent.conf  /etc/nginx/user_agent.conf
COPY ./docker/web/location.conf  /etc/nginx/location.conf
ADD ./docker/web/bots.d /etc/nginx/bots.d
# certs
COPY ./docker/web/privkey.pem /etc/nginx/privkey.pem
COPY ./docker/web/fullchain.pem /etc/nginx/fullchain.pem

# substitute variable references in the Nginx config template for real values from the environment
# put the final config in its place
RUN envsubst '$RAILS_ROOT' < /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD ["nginx", "-g", "daemon off;"]
