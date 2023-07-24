#!/bin/bash
git clone $GIT_REPO repository
cd repository
rm -rf $BACKUP_NAME/
mkdir $BACKUP_NAME
# if MONGODB_URI is set but not POSTGRES_URI
if [ -n "$MONGODB_URI" ] && [ -z "$POSTGRES_URI" ]; then
    # mongo dump
    mongodump --uri  $MONGODB_URI --authenticationDatabase=admin
    # if folder $BACKUP_NAME does not exist, create it
    mv dump/* $BACKUP_NAME/
    rm -rf dump

    # if one file in the $BACKUP_NAME folder is larger than 100 mb
    if [ $(find $BACKUP_NAME -type f -size +99M 2>/dev/null) ]; then
        echo "File is larger than 100 mb, compressing..."
        # tar gzip the folder
        tar -czvf $BACKUP_NAME.tar.gz $BACKUP_NAME
        # remove original folder
        rm -rf $BACKUP_NAME
        mkdir $BACKUP_NAME
        mv $BACKUP_NAME.tar.gz $BACKUP_NAME/
    fi
fi
# if POSTGRES_URI is set but not MONGODB_URI
if [ -n "$POSTGRES_URI" ] && [ -z "$MONGODB_URI" ]; then
    # postgres dump
    # parse password from uri, it's between the first : and the first @ 
    POSTGRES_PASSWORD=$(echo $POSTGRES_URI | cut -d: -f1 | cut -d@ -f1)
    PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall -d postgres://$POSTGRES_URI > $BACKUP_NAME/backup.sql
    # check if outputfile is larger or equal to 100 mb
    if [ $(wc -c <"$BACKUP_NAME/backup.sql") -ge 100000000 ]; then
        echo "File is larger than 100 mb, compressing..."
        # tar gzip the file
        tar -czvf $BACKUP_NAME/backup.sql.tar.gz $BACKUP_NAME/backup.sql
        # remove original file
        rm $BACKUP_NAME/backup.sql
    fi
fi
# if both are set show an error message
if [ -n "$POSTGRES_URI" ] && [ -n "$MONGODB_URI" ]; then
    echo "Both MONGODB_URI and POSTGRES_URI are set. Please set only one of them."
fi
# if one or the other is set
if [ -n "$POSTGRES_URI" ] || [ -n "$MONGODB_URI" ]; then
    # git commit
    git add -A
    git commit -m "autobackup from docker"
    git push origin main  
fi