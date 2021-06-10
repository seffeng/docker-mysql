#!/bin/bash

init_database_dir() {
    if [ ! -d ${BASE_DIR}/data/mysql/mysql ]; then
        mkdir -p ${BASE_DIR}/data/mysql
        chown -R mysql:mysql ${BASE_DIR}/data/mysql ${BASE_DIR}/logs ${BASE_DIR}/tmp
        mysql_install_db --user=mysql --datadir=${BASE_DIR}/data/mysql
        mysql_ssl_rsa_setup --datadir=${BASE_DIR}/data/mysql
    fi
}

init_database_dir

exec "$@"