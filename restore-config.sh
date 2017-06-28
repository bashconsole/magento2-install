#!/bin/bash

# Magento restore configuration from backup script
# Author: EVRY

function usage {
    echo ""
    echo "Usage:"
    echo ""
    echo "$0 -f <backup_file> -u <database_username> -p <database_password> -d <database_name> [-h <database_hostname>]"
    echo ""
    echo "   -f     Magento backup filename where configuration (core_config_data table) should be taken from"
    echo "   -u     Database username"
    echo "   -p     Database password"
    echo "   -d     Database name"
    echo "   -h     Database hostname"
    echo ""
    echo "Examples:"
    echo "   restore-config.sh -f 1498528802_db.sql -u user -p password -d namedb -h localhost"
    echo ""
    exit $1
}

DBHOST='localhost'
DBPASSWORD=
DBDATABASE=
DBFILENAME=
DBUSER=


while getopts "u:p:d:h:f:" opt ; do
    case $opt in
        u) DBUSER=$OPTARG
          ;;
        p) DBPASSWORD=$OPTARG
          ;;
        d) DBDATABASE=$OPTARG
          ;;
        h) DBHOST=$OPTARG
          ;;
        f) DBFILENAME=$OPTARG
          ;;
        \?) echo "Invalid option: -${opt}" >&2; usage 1;;
    esac
done


if [ -z "${DBUSER}" ]; then echo "ERROR: Please provide database user"; usage 1; fi
if [ -z "${DBPASSWORD}" ]; then echo "ERROR: Please provide database password"; usage 1; fi
if [ -z "${DBDATABASE}" ]; then echo "ERROR: Please provide database name"; usage 1; fi
if [ -z "${DBFILENAME}" ]; then echo "ERROR: Please provide backups filename"; usage 1; fi
if [ -z "${DBHOST}" ]; then echo "ERROR: Please provide database host"; usage 1; fi

DBTMP=${DBFILENAME%.sql}


echo "Database user: ${DBUSER}"
echo "Database password: ${DBPASSWORD}"
echo "Database name: ${DBDATABASE}"
echo "Database host: ${DBHOST}"
echo "Backups file to use data from: ${DBFILENAME}"
echo "Temporary database: ${DBTMP}"

while true; do
    read -p "Do you wish to continue? (y/N)" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done


mysql -u${DBUSER} -p${DBPASSWORD} -e "create database ${DBTMP}"
mysql -u${DBUSER} -p${DBPASSWORD} ${DBTMP} < ${DBFILENAME}
mysqldump -u${DBUSER} -p${DBPASSWORD} ${DBTMP} core_config_data > /tmp/core_config_data.sql
mysql -u${DBUSER} -p${DBPASSWORD} -e "drop database ${DBTMP}"
mysql -u${DBUSER} -p${DBPASSWORD} ${DBDATABASE} -e "drop table core_config_data"
mysql -u${DBUSER} -p${DBPASSWORD} ${DBDATABASE} < /tmp/core_config_data.sql


echo "Done."

