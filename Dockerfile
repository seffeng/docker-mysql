FROM seffeng/debian:latest

MAINTAINER  seffeng "seffeng@sina.cn"

ENV BASE_DIR="/opt/websrv"

ENV MYSQL_VERSION=5.7\
 CONFIG_DIR="${BASE_DIR}/config/mysql"\
 GPU_KEY="8C718D3B5072E1F5"\
 MYSQL_PASSWORD=""\
 BASE_PACKAGE="gnupg"\
 EXTEND="openssl"

WORKDIR /tmp
COPY    conf ./conf
COPY    docker-entrypoint.sh /usr/local/bin/

RUN \
 apt-get update && apt-get -y --no-install-recommends install ${BASE_PACKAGE} ${EXTEND} &&\
 gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "${GPU_KEY}" &&\
 gpg --batch --export "${GPU_KEY}" > /etc/apt/trusted.gpg.d/mysql.gpg &&\
 echo "deb http://repo.mysql.com/apt/debian/ buster mysql-${MYSQL_VERSION}" > /etc/apt/sources.list.d/mysql.list &&\
 echo mysql-community-server mysql-community-server/root-pass password "${MYSQL_PASSWORD}" | debconf-set-selections &&\
 echo mysql-community-server mysql-community-server/re-root-pass password "${MYSQL_PASSWORD}" | debconf-set-selections &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${BASE_DIR}/data/mysql &&\
 apt-get update && apt-get -y install mysql-server &&\
 chown -R mysql:mysql ${BASE_DIR}/data/mysql ${BASE_DIR}/logs ${BASE_DIR}/tmp &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
 mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak &&\
 ln -s ${CONFIG_DIR}/my.cnf /etc/mysql/my.cnf &&\
 rm -rf /usr/bin/mysql_install_db /usr/sbin/mysqld-debug &&\
 apt-get -y remove ${BASE_PACKAGE} &&\
 apt-get clean &&\
 rm -rf /var/cache/apt/* &&\
 cd /tmp && rm -rf /tmp/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR}/data/mysql", "${BASE_DIR}/logs"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld_safe"]
