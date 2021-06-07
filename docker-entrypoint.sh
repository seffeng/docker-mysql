#!/bin/bash
${INSTALL_DIR}/bin/mysqld --initialize-insecure --user=mysql --basedir=${INSTALL_DIR} --datadir=${BASE_DIR}/data/mysql

${INSTALL_DIR}/bin/mysql_ssl_rsa_setup --datadir=${BASE_DIR}/data/mysql

exec "$@"