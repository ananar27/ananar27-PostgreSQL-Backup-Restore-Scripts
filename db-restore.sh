#!/bin/bash
BACKUP_DIR=/opt/backups
CURR_DATE=$(date +'%d.%m.%Y_%H.%M')
DB_NAME=testdb
USER=postgres
BACKUP_NAME=$(find $BACKUP_DIR/$DB_NAME-*.pgdmp -type f -mtime -3 | sort -r | head -n 1)

if [[ ! $(find $BACKUP_DIR/$DB_NAME-*.pgdmp -type f -mtime -3) ]]; then
    echo "There are no backups. Make sure you've made a backup before continuing with this script"
    exit 1
else
    psql -U $USER -w -c "DROP DATABASE IF EXISTS $DB_NAME;"
    psql -U $USER -w -c "CREATE DATABASE $DB_NAME;"

    pg_restore -U $USER -w -d $DB_NAME < $BACKUP_NAME
    vacuumdb -U $USER -w -d $DB_NAME -z
    if [[ $? == 0 ]]; then
        echo -e "\nDB \"$DB_NAME\" has been restored succesfully\n"
    else
        echo -e "\nSomething has gone wrong. Try restoring DB \"$DB_NAME\" again\n"
        exit 1
    fi

    if [[ $(psql -U $USER -w -d $DB_NAME -c "SELECT * FROM pg_stat_activity;") ]]; then
        echo -e "\nDB \"$DB_NAME\" is running\n"
    else
        echo -e "\nSomething has gone wrong. Try running DB \"$DB_NAME\" again\n"
        exit 1
    fi

fi