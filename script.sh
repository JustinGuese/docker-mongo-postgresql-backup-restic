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
    # git commit
    git add -A
    git commit -m "autobackup mongodb from docker"
    git push origin main  
fi
# if POSTGRES_URI is set but not MONGODB_URI
if [ -n "$POSTGRES_URI" ] && [ -z "$MONGODB_URI" ]; then
    # postgres dump
    pg_dumpall -d postgres://$POSTGRES_URI > $BACKUP_NAME/backup.sql
    # git commit
    git add -A
    git commit -m "autobackup psql from docker"
    git push origin main  
fi
# if both are set show an error message
if [ -n "$POSTGRES_URI" ] && [ -n "$MONGODB_URI" ]; then
    echo "Both MONGODB_URI and POSTGRES_URI are set. Please set only one of them."
fi