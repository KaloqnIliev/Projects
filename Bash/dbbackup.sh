#!/bin/bash

# MySQL user credentials
USER="your_username"
PASSWORD="your_password"

# Database name
DATABASE="db01"

# Backup file name
BACKUP_FILE="reserve.txt"

# Log file name
LOG_FILE="logs"

# Backup the database and save the output to the log file
mysqldump -u $USER -p$PASSWORD $DATABASE > $BACKUP_FILE 2>> $LOG_FILE

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Database backup successful!" >> $LOG_FILE
else
  echo "Database backup failed!" >> $LOG_FILE
fi

# Monitor the database and store the output
mysqladmin -u $USER -p$PASSWORD status >> $LOG_FILE
