#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Set variables
LOCAL_PATH="/path/to/your/local/keepass/database"
REMOTE_PATH="gdrive:/sync"
DATABASE_NAME="passwords.kdbx"

TEMP_DIR="/tmp/keepass_sync_$$"  # Use PID to create a unique temp directory
TEMP_REMOTE_DB="$TEMP_DIR/remote_database.kdbx"
MERGED_DB="$TEMP_DIR/merged_database.kdbx"

# Create temp directory
mkdir -p "$TEMP_DIR"

# Cleanup function
cleanup() {
  rm -rf "$TEMP_DIR"
}

# Set trap to call cleanup function on script exit
trap cleanup EXIT

# Check if remote file exists
if rclone lsf "$REMOTE_PATH/$DATABASE_NAME"; then
  echo "Remote file found. Proceeding with sync."
else
  echo "Remote file not found. Uploading local database."
  rclone copy "$LOCAL_PATH/$DATABASE_NAME" "$REMOTE_PATH"
  echo "Upload complete. Exiting."
  exit 0
fi

# Download the remote database
rclone copy "$REMOTE_PATH/$DATABASE_NAME" "$TEMP_REMOTE_DB"

# Check if downloaded remote file exists and is different from local
if [ -f "$TEMP_REMOTE_DB" ] && ! cmp -s "$LOCAL_PATH/$DATABASE_NAME" "$TEMP_REMOTE_DB"; then
    echo "Changes detected. Merging databases."
    # Merge databases
    keepass merge --db1 "$LOCAL_PATH/$DATABASE_NAME" --db2 "$TEMP_REMOTE_DB" -o "$MERGED_DB"
    
    # If merge successful, replace local with merged
    if [ $? -eq 0 ]; then
        mv "$MERGED_DB" "$LOCAL_PATH/$DATABASE_NAME"
        echo "Merge successful. Local database updated."
    else
        echo "Merge failed. Manual intervention required."
        exit 1
    fi
else
    echo "No changes detected. Local database is up to date."
fi

# Sync merged/local database to remote
echo "Syncing local database to remote."
rclone sync "$LOCAL_PATH/$DATABASE_NAME" "$REMOTE_PATH"

echo "Sync completed successfully."


