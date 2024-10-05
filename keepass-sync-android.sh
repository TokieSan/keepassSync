#!/data/data/com.termux/files/usr/bin/bash

# Set variables
REMOTE_PATH="gdrive:sync" # Here the rclone name is gdrive & path of the folder is sync
LOCAL_PATH="/data/data/com.termux/files/home/storage/shared/sync" # Make sure this folder exists and has 0700 permission
DATABASE_NAME="salamon.kdbx"

# Ensure local directory exists
mkdir -p "$LOCAL_PATH"

# Sync from Google Drive to local
rclone sync "$REMOTE_PATH/$DATABASE_NAME" "$LOCAL_PATH/$DATABASE_NAME"

# Notify user of sync completion
termux-notification --title "KeePass Sync" --content "Database synced from Google Drive"

# Wait for KeePassDX to close
while pgrep -f com.kunzisoft.keepass.libre >/dev/null; do
    sleep 60
done

# Sync from local to Google Drive
rclone sync "$LOCAL_PATH/$DATABASE_NAME" "$REMOTE_PATH"

# Notify user of upload completion
termux-notification --title "KeePass Sync" --content "Database uploaded to Google Drive"
