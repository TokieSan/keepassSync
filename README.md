# KeyPass Sync: Sync KeyPass Database With Google Drive

## Overview
This system uses Termux, a terminal emulator for Android, to automate the synchronization of your KeePass database between your Android device and Google Drive. It provides a flexible, scriptable solution that can be triggered easily using Termux:Widget or an automation app like tasker. Also, it automates the synchronization with any linux device.

## Components
1. Google Drive (cloud storage)
2. Rclone (for both Linux and Android)
3. Termux (terminal emulator for Android)
4. Termux:API (for additional Android integration)
5. Termux:Widget (for easy script execution) [Optional]
6. Automation By Jens Schroder (for automating the script running) [Optional]


## Setup

### Laptop Setup
1. Install rclone on Arch or use whatever package manager you have:
   ```
   sudo pacman -S rclone
   ```

2. Configure rclone for Google Drive:
   ```
   rclone config
   # Follow prompts to set up a new remote for Google Drive
   ```

3. Download `keepass-sync.sh` file from the repository and modify the variables to your chosen directories.


4. Make the script executable:
   ```
   chmod +x keepass-sync.sh
   ```

5. Set up a cron job to run the script periodically:
   ```
   crontab -e
   # Add the following line to run the script every 15 minutes:
   */15 * * * * /path/to/keepass-sync.sh
   ```

### Android Phone Setup
1. Install Termux, Termux:API, and Termux:Widget from Google Play Store or F-Droid.

2. Open Termux and run the following commands:
   ```bash
   pkg update
   pkg upgrade
   pkg install rclone termux-api
   ```

3. Configure rclone for Google Drive:
   ```
   rclone config
   # Follow prompts to set up a new remote for Google Drive
   ```
4. Download the android script file and add it to termux `keepass-sync-android.sh` and modify the variables to your chosen directories.


5. Make the script executable:
   ```
   chmod +x keepass-sync.sh
   ```

*If you want to use a widget*

    6. Set up Termux:Widget:
    ```
    mkdir -p ~/.termux/tasker
    cp keepass-sync.sh ~/.termux/tasker/
    ```

    7. Add the Termux:Widget to your home screen and configure it to run the `keepass-sync.sh` script.


*If you want to use Automation app*
    6. Add the script as running script in the app (you may need to make it as a parameter to /system/bin/sh program)

## Usage

### On your laptop:
- The script will run automatically every 15 minutes (or as configured in your cron job).
- You can also run the script manually if needed.

### On your Android phone:
1. Before opening KeePassDX, tap the Termux:Widget to run the sync script (no need if you used Automation).
2. Wait for the notification that confirms the sync is complete.
3. Open KeePassDX and use your database as normal.
4. After closing KeePassDX, the script will automatically upload any changes to Google Drive.

## Conflict Resolution
- The script uses KeePass's built-in merge functionality to resolve conflicts.
- If automatic merging fails, you'll need to manually resolve conflicts using KeePassXC on your laptop.

## Best Practices
- Always run the sync script before opening KeePassDX to ensure you have the latest version (in case you're using the widget).
- Keep a local backup of your database on both devices (this is already done with the computer).
- Regularly check sync notifications to ensure the process is working correctly.
