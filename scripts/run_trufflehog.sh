#!/bin/bash

# Capture the current working directory (should be secrets-in-the-source)
BASE_DIR=$(pwd)

# Define the output directory for TruffleHog reports
OUTPUT_DIR="$BASE_DIR/reports/trufflehog_output"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR" || { echo "Failed to create $OUTPUT_DIR directory"; exit 1; }

# Change to the repos directory
cd "$BASE_DIR/repos" || { echo "Failed to change to $BASE_DIR/repos directory"; exit 1; }

# Loop over all repositories and run TruffleHog
for repo in *; do
    if [ -d "$repo" ]; then  # Check if it's a directory (repo)
        echo "Running TruffleHog on $repo..."
        
        # Run TruffleHog and save the output to the reports folder
        sudo trufflehog filesystem "$repo" --no-update --json > "$OUTPUT_DIR/$repo.json" || echo "Failed to write TruffleHog output for $repo"
        
        echo "Output saved for $repo in $OUTPUT_DIR/$repo.json"
    fi
done

echo "TruffleHog scan complete for all repositories!"
