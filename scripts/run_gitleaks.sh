#!/bin/bash
mkdir -p ./reports/gitleaks_output
for repo in ./repos/*; do
    name=$(basename "$repo")
    gitleaks detect --source="$repo" --report-format=json --report-path="./reports/gitleaks_output/$name.json"
done
