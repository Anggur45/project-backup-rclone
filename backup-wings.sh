#!/bin/bash

# Configuration
BACKUP_DIR="/root/wings_backup"
DATE=$(date +"%Y-%m-%d-%H-%M")  # Date format: year-month-day-hour-minute
MYIP=$(curl -s ipinfo.io/ip)    # Get public IP
REMOTE_NAME="name_remte"        # rclone remote name
FILE_WINGS="/var/lib/pterodactyl/volumes"  # Location of Wings volumes directory
ZIP_FILE="$BACKUP_DIR/wings-$DATE.zip"     # Zip file name

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Backup Wings volumes directory to zip file
echo "Backing up Wings volumes to zip file..."
cd "$FILE_WINGS" || exit
zip -r "$ZIP_FILE" .  # Zip the entire contents of the volumes directory

# Upload zip file to remote storage
echo "Uploading zip file to remote storage..."
rclone copy "$ZIP_FILE" "$REMOTE_NAME:backup/$MYIP/wings/volumes/"

# Remove local zip file after upload
rm "$ZIP_FILE"

echo "Backup completed and uploaded to remote storage."
