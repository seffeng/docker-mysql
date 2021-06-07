FROM seffeng/debian:latest

MAINTAINER  seffeng "seffeng@sina.cn"

ARG BASE_DIR="/opt/websrv"

ENV MYSQL_VERSION=5.7.34\
 CONFIG_DIR="${BASE_DIR}/config/mysql"\
 INSTALL_DIR="${BASE_DIR}/program/mysql"\
 BASE_PACKAGE="wget gcc g++ make file perl zlib1g-dev cmake autoconf libncurses5-dev apt-utils libssl-dev pkg-config libbison-dev"

ENV MYSQL_URL="https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-${MYSQL_VERSION}.tar.gz"

WORKDIR /tmp
COPY    conf ./conf

RUN \
 apt-get update && apt-get -y --no-install-recommends install ${BASE_PACKAGE} &&\
 wget ${MYSQL_URL} &&\
 tar -zxf mysql-boost-${MYSQL_VERSION}.tar.gz &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${INSTALL_DIR} ${BASE_DIR}/data/mysql &&\
 groupadd mysql && useradd -M -s /sbin/nologin -g mysql mysql &&\
 chown -R mysql:mysql ${BASE_DIR}/data/mysql &&\
 chmod 777 ${BASE_DIR}/logs ${BASE_DIR}/tmp &&\
 cd mysql-${MYSQL_VERSION} &&\
 cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DSYSCONFDIR=${CONFIG_DIR} -DMYSQL_UNIX_ADDR=${BASE_DIR}/tmp/mysql.sock -DMYSQL_DATADIR=${BASE_DIR}/data/mysql -DMYSQL_TCP_PORT=3306 -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DWITH_EXTRA_CHARSETS=all -DWITH_BOOST=/tmp/mysql-${MYSQL_VERSION}/boost . &&\
 make && make install &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
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
 cd ${INSTALL_DIR} &&\
 rm -rf mysql-test &&\
 rm -rf lib/libmysqld.a &&\
 cd bin &&\
 rm -rf mysql_client_test mysql_client_test_embedded mysqltest mysqltest_embedded mysqlxtest mysql_install_db &&\
 apt-get -y remove ${BASE_PACKAGE} &&\
 apt-get clean &&\
 rm -rf /var/cache/apt/* &&\
 cd /tmp && rm -rf /tmp/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR}/data/mysql", "${BASE_DIR}/logs"]

EXPOSE 3306

CMD ["mysqld_safe"]
