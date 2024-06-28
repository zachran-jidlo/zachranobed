#!/bin/bash

# This script reads an input file (typically CHANGELOG.md) and extracts the content that falls under
# the first second-level heading. It is used to extract latest release notes.

# Read the input file
input="$1"

# Variables to track if we are inside the first sub-heading section
inside_heading=false

# Output buffer
output=""

# Read the input file line by line
while IFS= read -r line
do
  if [[ "$line" =~ ^##\  ]]; then
    if [ "$inside_heading" = true ]; then
      break
    else
      inside_heading=true
    fi
  fi

  if [ "$inside_heading" = true ]; then
    output+="$line"$'\n'
  fi
done < "$input"

# Print the output
echo "$output"
