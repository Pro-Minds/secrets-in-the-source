#!/bin/bash

# Capture the current working directory (should be secrets-in-the-source)
BASE_DIR=$(pwd)

# Define the path to repos.txt in the current directory
REPOS_FILE="$BASE_DIR/repos.txt"

# Ensure repos directory exists in secrets-in-the-source
mkdir -p ./repos || { echo "Failed to create ./repos directory"; exit 1; }

# Check if repos.txt exists and is not empty
if [[ ! -f "$REPOS_FILE" ]]; then
    echo "Error: $REPOS_FILE not found"
    exit 1
fi
if [[ ! -s "$REPOS_FILE" ]]; then
    echo "Error: $REPOS_FILE is empty"
    exit 1
fi

# Change to repos directory
cd ./repos || { echo "Failed to change to ./repos directory"; exit 1; }

# Read and clone repositories
while IFS= read -r repo_url; do
    if [[ -n "$repo_url" ]]; then
        echo "Cloning $repo_url"
        git clone --depth 1 "$repo_url" || echo "Failed to clone $repo_url"
    fi
done < "$REPOS_FILE"

echo "Cloning complete"
