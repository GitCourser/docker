FROM alpine

RUN apk --no-cache add nginx nginx-mod-http-js logrotate tzdata && \
    ln -s /usr/lib/nginx/modules/ngx_http_js_module.so /etc/nginx/modules/ngx_http_js_module.so && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/*

COPY entrypoint /entrypoint
COPY logrotate.conf /etc/logrotate.d/nginx

ENTRYPOINT ["/bin/sh", "/entrypoint"]