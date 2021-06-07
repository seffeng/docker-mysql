FROM seffeng/debian:latest

MAINTAINER seffeng "seffeng@sina.cn"

ARG BASE_DIR="/opt/websrv"

ENV MYSQL_VERSION=mysql-8.0.25-linux-glibc2.17-x86_64-minimal\
 CONFIG_DIR="${BASE_DIR}/config/mysql"\
 INSTALL_DIR="${BASE_DIR}/program/mysql"\
 BASE_PACKAGE="wget xz-utils"\
 EXTEND="libaio-dev libnuma-dev libncurses5"

ENV MYSQL_URL="https://dev.mysql.com/get/Downloads/MySQL-8.0/${MYSQL_VERSION}.tar.xz"

WORKDIR /tmp
COPY    conf ./conf

RUN \
 apt-get update && apt-get -y install ${BASE_PACKAGE} ${EXTEND} &&\
 wget ${MYSQL_URL} &&\
 xz -d ${MYSQL_VERSION}.tar.xz &&\
 tar -xf ${MYSQL_VERSION}.tar &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${INSTALL_DIR} ${BASE_DIR}/data/mysql /etc/mysql &&\
 rm -rf ${INSTALL_DIR} &&\
 groupadd mysql && useradd -M -s /sbin/nologin -g mysql mysql &&\
 chown -R mysql:mysql ${BASE_DIR}/data/mysql ${BASE_DIR}/logs ${BASE_DIR}/tmp &&\
 mv ${MYSQL_VERSION} ${INSTALL_DIR} &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
 ln -s ${CONFIG_DIR}/my.cnf /etc/mysql/my.cnf &&\
 ${INSTALL_DIR}/bin/mysqld --initialize-insecure --user=mysql --basedir=${INSTALL_DIR} --datadir=${BASE_DIR}/data/mysql &&\
 ${INSTALL_DIR}/bin/mysql_ssl_rsa_setup --datadir=${BASE_DIR}/data/mysql &&\
 ln -s ${INSTALL_DIR}/bin/mysql /usr/bin/mysql &&\
 ln -s ${INSTALL_DIR}/bin/mysqld /usr/bin/mysqld &&\
 ln -s ${INSTALL_DIR}/bin/mysqladmin /usr/bin/mysqladmin &&\
 ln -s ${INSTALL_DIR}/bin/mysqlbinlog /usr/bin/mysqlbinlog &&\
 ln -s ${INSTALL_DIR}/bin/mysqlcheck /usr/bin/mysqlcheck &&\
 ln -s ${INSTALL_DIR}/bin/mysql_config /usr/bin/mysql_config &&\
 ln -s ${INSTALL_DIR}/bin/mysqldump /usr/bin/mysqldump &&\
 ln -s ${INSTALL_DIR}/bin/mysqlimport /usr/bin/mysqlimport &&\
 ln -s ${INSTALL_DIR}/bin/mysqlshow /usr/bin/mysqlshow &&\
 ln -s ${INSTALL_DIR}/bin/mysqlslap /usr/bin/mysqlslap &&\
 ln -s ${INSTALL_DIR}/bin/mysqld_safe /usr/bin/mysqld_safe &&\
 apt-get -y remove ${BASE_PACKAGE} &&\
 apt-get clean &&\
 rm -rf /var/cache/apt/* &&\
 cd /tmp && rm -rf /tmp/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR}/data/mysql", "${BASE_DIR}/logs"]

EXPOSE 3306

CMD ["mysqld_safe"]
