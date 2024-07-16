#!/bin/bash

# Check if script is run as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Function to read user input with a prompt
read_input() {
    read -p "$1: " input
    echo "$input"
}

# Get domain name from the user
domain_name=$(read_input "Enter Domain Name")

# Check the Let's Encrypt certificate expiration date
expiration_date=$(grep "fullchain.pem expires on" /var/log/letsencrypt/letsencrypt.log | grep "$domain_name" | tail -1)

# Display the result
if [ -n "$expiration_date" ]; then
    echo "Certificate for $domain_name expires on: $expiration_date"
else
    echo "No valid certificate information found for $domain_name."
fi
