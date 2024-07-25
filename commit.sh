#!/bin/bash

# Array of repositories
repos=(
  "/var/www/api"
  "/var/www/doobeedoo.be"
  "/var/www/noordzee105.be"
  "/var/www/Phpmailer"
  "/etc/apache2"
  "/etc/icecast2"
  "/home/bernard/statter"
  "/opt/scripts"
)




# Function to commit and push changes
commit_and_push() {
  repo_path=$1
  cd $repo_path || { echo "Failed to cd into $repo_path"; exit 1; }
  
  # Check if the directory is a git repository
  if [ -d .git ]; then
    git add .
    current_date_time=$(date "+%Y-%m-%d %H:%M:%S")
    commit_message="Automated commit and push of changes on $current_date_time"

    git commit -m "$commit_message"
    git push
  else
    echo "$repo_path is not a git repository"
  fi
}

# Loop through each repository and commit/push changes
for repo in "${repos[@]}"; do
  echo "Processing $repo"
  commit_and_push "$repo"
done

echo "All repositories have been processed."
