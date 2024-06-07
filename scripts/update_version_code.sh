#!/bin/bash

# This script automatically updates the version number in project's pubspec.yaml file based on the
# count of commits in current branch.

# Check if inside a git repository
if [ ! -d .git ]; then
  echo "This is not a git repository."
  exit 1
fi

# Get the current branch commit count
commit_count=$(git rev-list --count HEAD)

# Check if commit_count is a number
if ! [[ "$commit_count" =~ ^[0-9]+$ ]]; then
  echo "Failed to get commit count."
  exit 1
fi

# Check if pubspec.yaml exists
if [ ! -f pubspec.yaml ]; then
  echo "pubspec.yaml not found."
  exit 1
fi

# Update the version in pubspec.yaml
# Assuming version follows a format like 'version: x.y.z+code'
# We will increment the "code" part (e.g., version: 1.0.0+1 -> version: 1.0.0+2)

# Extract the current version string
current_version=$(grep -E "^version: " pubspec.yaml)

# If no version string found, default to 1.0.0
if [ -z "$current_version" ]; then
  new_version="1.0.0+$commit_count"
else
  # Replace the code part with the new commit count
  new_version=$(echo "$current_version" | sed -E "s/\+([0-9]+)/+$commit_count/")
fi

# Update the pubspec.yaml with the new version
sed -i.bak "s/^version: .*/$new_version/" pubspec.yaml

# Print success message
echo "Updated pubspec.yaml to version: $new_version"
