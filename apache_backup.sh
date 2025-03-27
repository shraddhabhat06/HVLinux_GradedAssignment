#!/bin/bash
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_NAME="apache_backup_$TIMESTAMP.tar.gz"
tar -czf $BACKUP_DIR/$BACKUP_NAME /etc/httpd /var/www/html
echo "Backup completed: $BACKUP_NAME"
tar -tzf $BACKUP_DIR/$BACKUP_NAME > $BACKUP_DIR/apache_backup_verify.log
