#!/bin/bash

# Configuration
BACKUP_DIR="/root/pterodactyl_backup"
DATE=$(date +"%Y-%m-%d-%H-%M")  # Date format: year-month-day-hour-minute
MYIP=$(curl -s ipinfo.io/ip)    # Get public IP
REMOTE_NAME="name_remte"        # Configured rclone remote name
DB_NAME="pterodactyl"           # Your Pterodactyl database name
DB_USER="root"                  # Database user
DB_PASS="password"              # Database password
FILE_ENV="/var/www/pterodactyl/.env"
FILE_DATABASE="$BACKUP_DIR/pterodactyl_db_$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Backup database
echo "Backing up database..."
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > "$FILE_DATABASE"

# Backup .env file
echo "Backing up .env file..."
rclone copy "$FILE_ENV" "$REMOTE_NAME:backup/$MYIP/pterodactyl/env/"

# Backup database file
echo "Backing up database file..."
rclone copy "$FILE_DATABASE" "$REMOTE_NAME:backup/$MYIP/pterodactyl/database/"

# Remove local database file after upload
rm "$FILE_DATABASE"

echo "Backup completed and uploaded to remote storage."
