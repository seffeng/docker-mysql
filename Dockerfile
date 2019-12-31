FROM seffeng/alpine:latest

MAINTAINER  seffeng "seffeng@sina.cn"

ARG BASE_DIR="/opt/websrv"

ENV MYSQL_VERSION=5.7.28\
 CONFIG_DIR="${BASE_DIR}/config/mysql"\
 INSTALL_DIR="${BASE_DIR}/program/mysql"\
 BASE_PACKAGE="gcc g++ make file libc-dev cmake linux-headers perl autoconf "

ENV MYSQL_URL="https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-${MYSQL_VERSION}.tar.gz"

WORKDIR /tmp
COPY     mysql-boost-${MYSQL_VERSION}.tar.gz ./
COPY    conf ./conf

RUN apk update && apk add --no-cache ${BASE_PACKAGE} &&\
 # wget ${MYSQL_URL} &&\
 tar -zxf mysql-boost-${MYSQL_VERSION}.tar.gz &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${INSTALL_DIR} ${BASE_DIR}/data/mysql &&\
 addgroup mysqls && adduser -H -D -G mysqls mysql &&\
 chown -R mysql:mysqls ${BASE_DIR}/data/mysql &&\
 cd mysql-${MYSQL_VERSION} &&\
 cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DSYSCONFDIR=${CONFIG_DIR} -DMYSQL_UNIX_ADDR=${BASE_DIR}/tmp/mysql.sock -DMYSQL_DATADIR=${BASE_DIR}/data/mysql -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8mb4 -DMYSQL_TCP_PORT=3306 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_MyISAM_STORAGE_ENGINE=1 -DWITH_InnoDB_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DWITH_EXTRA_CHARSETS:STRING=all -DWITH_BOOST=/tmp/mysql-${MYSQL_VERSION}/boost &&\
 make && make install &&\
 cp -f ./support-files/mysql.server /etc/init.d/mysql.server &&\
 chmod 755 /etc/init.d/mysql.server &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
 ${INSTALL_DIR}/bin/mysqld --initialize-insecure --user=mysql --basedir=${INSTALL_DIR} --datadir=${BASE_DIR}/data/mysql &&\
 ${INSTALL_DIR}/bin/mysql_ssl_rsa_setup --datadir=${BASE_DIR}/data/mysql &&\
 ${INSTALL_DIR}/bin/mysqld_safe --user=mysql &&\
 ln -s ${INSTALL_DIR}/bin/mysql /usr/bin/mysql &&\
 apk del ${BASE_PACKAGE} &&\
 rm -rf /var/cache/apk/* &&\
 rm -rf /tmp/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR/data/mysql", "${BASE_DIR}/logs"]

EXPOSE 3306

CMD ["/etc/init.d/mysql.server", "start"]