FROM seffeng/debian:latest

MAINTAINER seffeng "seffeng@sina.cn"

ENV BASE_DIR="/opt/websrv"

ENV MYSQL_VERSION=mysql-5.7.37-linux-glibc2.12-x86_64\
 CONFIG_DIR="${BASE_DIR}/config/mysql"\
 INSTALL_DIR="${BASE_DIR}/program/mysql"\
 BASE_PACKAGE="wget"\
 EXTEND="libaio-dev libnuma-dev libncurses5"

ENV MYSQL_URL="https://dev.mysql.com/get/Downloads/MySQL-5.7/${MYSQL_VERSION}.tar.gz"

WORKDIR /tmp
COPY    conf ./conf
COPY    docker-entrypoint.sh /usr/local/bin/

RUN \
 apt-get update && apt-get -y install ${BASE_PACKAGE} ${EXTEND} &&\
 wget ${MYSQL_URL} &&\
 tar -xf ${MYSQL_VERSION}.tar.gz &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${INSTALL_DIR} ${BASE_DIR}/data/mysql /etc/mysql &&\
 rm -rf ${INSTALL_DIR} &&\
 groupadd mysql && useradd -M -s /sbin/nologin -g mysql mysql &&\
 chown -R mysql:mysql ${BASE_DIR}/data/mysql ${BASE_DIR}/logs ${BASE_DIR}/tmp &&\
 mv ${MYSQL_VERSION} ${INSTALL_DIR} &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
 ln -s ${CONFIG_DIR}/my.cnf /etc/mysql/my.cnf &&\
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
 rm -rf ${INSTALL_DIR}/bin/mysql_client_test_embedded ${INSTALL_DIR}/bin/mysql_embedded ${INSTALL_DIR}/bin/mysqld-debug &&\
 rm -rf ${INSTALL_DIR}/bin/mysqltest_embedded ${INSTALL_DIR}/bin/mysqlxtest ${INSTALL_DIR}/bin/mysql_install_db &&\
 apt-get -y remove ${BASE_PACKAGE} &&\
 apt-get clean &&\
 rm -rf /var/cache/apt/* &&\
 cd /tmp && rm -rf /tmp/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR}/data/mysql", "${BASE_DIR}/logs"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld_safe"]
