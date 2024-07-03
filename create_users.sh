#!/bin/bash

# Ensure script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Check if the input file is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE=$1

# Check if the input file exists
if [ ! -f $INPUT_FILE ]; then
    echo "Input file not found!"
    exit 1
fi

# Log file path
LOG_FILE="/var/log/user_management.log"
# Password file path
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Create the secure directory if it doesn't exist
mkdir -p /var/secure
chmod 700 /var/secure

# Create the log file if it doesn't exist and set permissions
touch $LOG_FILE
chmod 600 $LOG_FILE

# Function to log messages with timestamps
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Loop through each line in the input file
while IFS=";" read -r username groups; do
    # Remove leading and trailing whitespace
    username=$(echo $username | xargs)
    groups=$(echo $groups | xargs)

    # Create the user group if it doesn't exist
    if ! getent group "$username" >/dev/null; then
        groupadd "$username"
        log_message "Group $username created."
    else
        log_message "Group $username already exists."
    fi

    # Create the user if it doesn't exist
    if ! id -u "$username" >/dev/null 2>&1; then
        useradd -m -g "$username" -s /bin/bash "$username"
        log_message "User $username created with home directory."
    else
        log_message "User $username already exists."
        continue
    fi

    # Add user to additional groups specified
    IFS=',' read -ra ADDR <<< "$groups"
    for group in "${ADDR[@]}"; do
        group=$(echo $group | xargs)
        if ! getent group "$group" >/dev/null; then
            groupadd "$group"
            log_message "Group $group created."
        fi
        usermod -aG "$group" "$username"
        log_message "User $username added to group $group."
    done

    # Generate a random password for the user
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd
    echo "$username,$password" >> $PASSWORD_FILE  # Store password in CSV format
    log_message "Password for user $username set and stored."

    # Set permissions for the user's home directory
    chmod 700 /home/"$username"
    chown "$username":"$username" /home/"$username"
    log_message "Permissions for /home/$username set to 700 and ownership set to $username:$username."

done < "$INPUT_FILE"

echo "User creation process completed."
exit 0
