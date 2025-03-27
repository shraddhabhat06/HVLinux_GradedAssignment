#!/bin/bash
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_NAME="nginx_backup_$TIMESTAMP.tar.gz"
tar -czf $BACKUP_DIR/$BACKUP_NAME /etc/nginx /usr/share/nginx/html
echo "Backup completed: $BACKUP_NAME"
tar -tzf $BACKUP_DIR/$BACKUP_NAME > $BACKUP_DIR/nginx_backup_verify.log
