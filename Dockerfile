FROM seffeng/alpine:latest

MAINTAINER  seffeng "seffeng@sina.cn"

ARG BASE_DIR="/opt/websrv"

ENV CONFIG_DIR="${BASE_DIR}/config/mysql"

WORKDIR /tmp
COPY    conf ./conf

RUN apk add --update --no-cache mysql &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${BASE_DIR}/data/mysql &&\
 chmod 777 ${BASE_DIR}/tmp &&\
 chmod 777 ${BASE_DIR}/logs &&\
 rm -f /etc/my.cnf &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
 ln -s ${CONFIG_DIR}/my.cnf /etc/my.cnf &&\
 mysql_install_db --user=mysql --datadir=${BASE_DIR}/data/mysql --skip-test-db &&\
 cp -f /usr/share/mariadb/mysql.server /etc/init.d/mysql.server &&\
 rm -rf /var/cache/apk/* &&\
 rm -rf /tmp/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR}/data/mysql", "${BASE_DIR}/logs"]

EXPOSE 3306

CMD ["/etc/init.d/mysql.server", "start"]