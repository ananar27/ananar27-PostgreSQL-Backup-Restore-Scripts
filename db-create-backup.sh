#!/bin/bash
BACKUP_DIR=/opt/backups
CURR_DATE=$(date +'%d.%m.%Y_%H.%M')
DB_NAME=testdb
USER=postgres
function create_backups {
    echo "Creating a new backup" 
    pg_dump -U $USER -w $DB_NAME --format=c > $BACKUP_DIR/$DB_NAME-$CURR_DATE.pgdmp
    if [[ $? != 0 ]] ; then 
        echo "Something has gone wrong. Backup wasn't created" 
        exit 1
    else 
        echo "Backup \"$DB_NAME-$CURR_DATE.pgdmp\" was created"
    fi 
}

if [[ $(psql -U $USER -w -d $DB_NAME -c "SELECT * FROM pg_stat_activity;") ]]; then
    echo -e "\nDB \"$DB_NAME\" is running\n"
else
    echo -e "\nSomething has gone wrong. Try running DB \"$DB_NAME\" again\n"
    exit 1
fi

if ! [[ -d $BACKUP_DIR ]]; then
    echo "Folder \"$BACKUP_DIR\" doesn't exist" 
    exit 1
else

    if [[  -z "$(ls -A $BACKUP_DIR/$DB_NAME-*.pgdmp 2> /dev/null)" ]]; then
        echo "There are no backups" 
        create_backups

    elif [[ $(find $BACKUP_DIR/*.pgdmp -type f -mtime +3) ]]; then
        echo "There's an outdated backup file" 
        create_backups
        echo "Deleting older backup version" 
        find $BACKUP_DIR/*.pgdmp -type f -mtime +3 -delete 
        echo "Older backup version deleted"
    else 
        echo "Backup is up to date"
        exit 0
    fi
fi

if [[ $(pgrep -f pg_dump) == 0  ]]; then 
    echo -e "Wait a bit. DB backup is running\n";
else 
    echo -e "Backup is not running\n";
fi

if [[ $(psql -U $USER -w -d $DB_NAME -c "SELECT * FROM pg_stat_activity;") ]]; then
    echo -e "\nDB \"$DB_NAME\" is running\n"
else
    echo -e "\nSomething has gone wrong. Try running DB \"$DB_NAME\" again\n"
    exit 1
fi
