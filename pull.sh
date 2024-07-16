#!/bin/bash

# List of directories containing git repositories
repositories=(
    "/var/www/api"
    "/var/www/doobeedoo.be"
    "/var/www/noordzee105.be"
    "/var/www/Phpmailer"
    "/etc/apache2"
    "/etc/icecast2"
    "/home/bernard/statter"
)

# Function to update the repository
update_repo() {
    local repo_dir=$1

    if [ -d "$repo_dir" ]; then
        cd "$repo_dir" || return
        if [ -d ".git" ]; then
            echo "Updating repository in $repo_dir"
            git pull
        else
            echo "No git repository found in $repo_dir"
        fi
    else
        echo "Directory $repo_dir does not exist"
    fi
}

# Loop through each repository and update it
for repo in "${repositories[@]}"; do
    update_repo "$repo"
done
