import json
import os
from collections import Counter
import matplotlib.pyplot as plt

# List to store RuleIDs
rules = []

# Read all JSON files in reports/gitleaks_output/
for file in os.listdir('./reports/gitleaks_output'):
    file_path = f'./reports/gitleaks_output/{file}'
    with open(file_path, 'r') as f:
        try:
            # Load the entire file as a JSON array
            data = json.load(f)
            # Ensure data is a list (Gitleaks output should be an array)
            if isinstance(data, list):
                # Extract RuleID from each finding
                for finding in data:
                    if 'RuleID' in finding:
                        rules.append(finding['RuleID'])
        except json.JSONDecodeError as e:
            print(f"Error parsing {file_path}: {e}")
            continue
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
            continue

# Count occurrences of each RuleID
counts = Counter(rules)

# Check if counts is empty
if not counts:
    print("No secrets found in any repository.")
    # Create an empty plot with a message
    plt.figure(figsize=(10, 6))
    plt.title('Secrets by Type (GitLeaks)')
    plt.text(0.5, 0.5, 'No secrets detected', fontsize=12, ha='center', va='center')
    plt.xticks([])
    plt.yticks([])
    plt.tight_layout()
    plt.savefig('visuals/secret_types_chart.png')
    exit()

# Create bar chart
plt.figure(figsize=(10, 6))
plt.bar(counts.keys(), counts.values())
plt.xticks(rotation=90)
plt.xlabel('Secret Type (RuleID)')
plt.ylabel('Count')
plt.title('Secrets by Type (GitLeaks)')
plt.tight_layout()
plt.savefig('visuals/secret_types_chart.png')
print("Chart saved to visuals/secret_types_chart.png")
