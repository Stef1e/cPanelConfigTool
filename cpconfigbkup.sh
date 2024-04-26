#!/bin/bash

# Define text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#Check if sudo
if [ "$EUID" -ne 0 ];then
        echo -e "${RED}This script is required to be ran with sudo privileges!${NC}" 1>&2
        exit 1
fi

# Function to create a new backup
create_backup() {
    date=$(date +"%Y-%m-%d")
    backup_dir="/backup/WHM_configs/$date/"

    # Check if backup directory already exists for the current date
    if [ -d "$backup_dir" ]; then
        echo -e "${RED}A backup for today already exists.${NC}"
        echo -e "${YELLOW}Backup directory: $backup_dir${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Saving configuration backups to /backup/WHM_configs/${NC}"

    for i in $(/usr/local/cpanel/bin/cpconftool --list-modules);
        do /usr/local/cpanel/bin/cpconftool --backup --modules=$i --verbose | grep -i Backing;
    done

    mkdir -p "$backup_dir"

    rsync -zhva --remove-source-files /home/whm-config-backup-cpanel* "$backup_dir" 1>/dev/null

    echo -e "${GREEN}Done!${NC}"
    sleep 2

    echo ""

    echo -e "${YELLOW}The following backups have been saved in $backup_dir${NC}"
    sleep 0.5

    for file in "$backup_dir"*; do
        echo "$file"
        sleep 0.1
    done
}

# Function to restore an existing backup
restore_backup() {
    backup_dir="/backup/WHM_configs/"

    # List available backup directories and number them
    echo "Available backup directories:"
    backup_dates=($(ls -d /backup/WHM_configs/*-*-*))
    for ((i=0; i<${#backup_dates[@]}; i++)); do
        date=$(basename ${backup_dates[i]})
        echo "$(($i + 1)). $date"
    done

    # Prompt the user to choose a backup date by number
    read -p "Enter the number of the backup date you want to restore from: " choice

    # Validate user input
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -le 0 ] || [ "$choice" -gt ${#backup_dates[@]} ]; then
        echo "Invalid input. Please enter a valid number."
        exit 1
    fi

    selected_date="${backup_dates[choice - 1]}"
    cd "$selected_date"

/usr/local/cpanel/bin/cpconftool --restore=$selected_date/$(ls) --modules=cpanel::easy::apache,cpanel::smtp::exim,cpanel::system::autossloptions,cpanel::system::backups,cpanel::system::greylist,cpanel::system::hulk,cpanel::system::modsecurity,cpanel::system::mysql,cpanel::system::whmconf,cpanel::ui::themes --verbose
}
# Main menu
clear
echo -e "${YELLOW}Choose an option:${NC}"
echo "1. Create a new backup"
echo "2. Restore an existing backup"

read -p "Enter the number of your choice: " menu_choice

case "$menu_choice" in
    1) create_backup ;;
    2) restore_backup ;;
    *) echo "Invalid choice. Exiting." >&2; exit 1 ;;
esac
