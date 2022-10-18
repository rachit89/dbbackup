#!/usr/bin/env bash

DATE_FORMAT=$(date +"%Y-%m-%d")

# MySQL server credentials
MYSQL_HOST="wordpress.cnbwakbdzeez.us-east-2.rds.amazonaws.com"
MYSQL_PORT="3306"
MYSQL_USER="admin"
MYSQL_PASSWORD="password"

# Path to local backup directory
LOCAL_BACKUP_DIR="/home/ubuntu/backup/dbbackup"

# Set s3 bucket name and directory path
S3_BUCKET_NAME="rdsbackup-rachit"
S3_BUCKET_PATH="backups/db-backup"

# Use a single database or space separated database's names
DATABASES="wordpress"

mkdir -p ${LOCAL_BACKUP_DIR}/${DATE_FORMAT}

LOCAL_DIR=${LOCAL_BACKUP_DIR}/${DATE_FORMAT}
REMOTE_DIR=s3://${S3_BUCKET_NAME}/${S3_BUCKET_PATH}

for db in $DATABASES; do
   mysqldump -h ${MYSQL_HOST} \
         -P ${MYSQL_PORT} \
         -u ${MYSQL_USER} \
         -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} | gzip -9 > ${LOCAL_DIR}/${db}-${DATE_FORMAT}.sql.gz

        aws s3 cp ${LOCAL_DIR}/${db}-${DATE_FORMAT}.sql.gz ${REMOTE_DIR}/${DATE_FORMAT}/
done

rm ${LOCAL_DIR}/${db}-${DATE_FORMAT}.sql.gz
