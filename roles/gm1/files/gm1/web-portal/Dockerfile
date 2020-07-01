FROM zabbix/zabbix-web-nginx-mysql:alpine-5.0-latest

LABEL AUTHOR zx<"bryanzx@foxmail.com">

ADD default.conf /etc/nginx/conf.d/default.conf

ADD htpasswd /etc/nginx/htpasswd

ADD php-fpm.conf /etc/

ADD php-fpm.conf /etc/php7/php-fpm.conf
