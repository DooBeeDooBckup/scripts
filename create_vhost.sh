#!/bin/bash

# Function to read user input with a prompt
read_input() {
    read -p "$1: " input
    echo "$input"
}

# Check if DEBUG is set to true
if [ "$DEBUG" == "true" ]; then
    enable_restart=false
else
    enable_restart=true
fi

# Get server details from the user
server_name=$(read_input "Enter Server Name")
server_admin=$(read_input "Enter Server Admin")
document_root=$(read_input "Enter Document Root")
ssl_redirect=$(read_input "Redirect to SSL (yes/no)")
enable_www_alias=$(read_input "Enable www ServerAlias (yes/no)")
generate_cert=$(read_input "Generate Let's Encrypt certificate (yes/no)")


# Create the Apache configuration
config="
<VirtualHost *:80>
    ServerName $server_name"

if [ "$enable_www_alias" == "yes" ]; then
    config+="
    ServerAlias www.$server_name"
fi

config+="
    ServerAdmin $server_admin
    DocumentRoot $document_root"

if [ "$ssl_redirect" == "yes" ]; then
    config+="
    Redirect permanent / https://$server_name"
fi

config+="
    ErrorLog \${APACHE_LOG_DIR}/$server_name.error.log
    CustomLog \${APACHE_LOG_DIR}/$server_name.access.log combined"

if [ "$ssl_redirect" == "yes" ]; then
    config+="
    <IfModule mod_rewrite.c>
        RewriteEngine on
        RewriteCond %{SERVER_NAME} =$server_name
        RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
    </IfModule>"
fi

config+="
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

# Print the configuration or save to a file
if [ "$DEBUG" == "true" ]; then
    echo "Generated Apache configuration for $server_name:"
    echo "$config" | sudo tee /home/alain/scripting/$server_name.conf > /dev/null
else
    # Save the configuration to a file
    echo "$config" | sudo tee /etc/apache2/sites-available/$server_name.conf > /dev/null
    #echo "$config" | sudo tee /home/alain/scripting/$server_name.conf > /dev/null

    # Enable the site and restart Apache if needed
    if [ "$enable_restart" == "true" ]; then
        sudo a2ensite $server_name
        sudo systemctl restart apache2
        echo "Apache configuration for $server_name has been created and the site is enabled."

         # Generate Let's Encrypt certificate if requested
        if [ "$generate_cert" == "yes" ]; then
            sudo certbot --apache -d $server_name -d www.$server_name
        else
            echo "No certificate was generated. You can manually configure SSL for $server_name."
        fi
    else
        echo "Debug mode: Apache configuration for $server_name has been generated but the site is not enabled or Apache is not restarted."
    fi
fi
