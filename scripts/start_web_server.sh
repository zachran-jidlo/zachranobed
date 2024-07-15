#!/bin/bash

# This script could be used to launch web application locally.

# Function to find the project root directory. It searches upwards from the current directory until
# it finds a .git directory or README.md file.
find_project_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" && ! -d "$dir/.git" && ! -f "$dir/README.md" ]]; do
    dir=$(dirname "$dir")
  done
  if [[ "$dir" == "/" ]]; then
    echo "Error: Could not find project root."
    exit 1
  fi
  echo "$dir"
}

# Change to the project root directory
PROJECT_ROOT=$(find_project_root)
cd "$PROJECT_ROOT" || exit 1

# File to edit
FILE="build/web/index.html"

# Check if the file exists
if [[ ! -f "$FILE" ]]; then
  echo "Error: $FILE not found!"
  exit 1
fi

# Replace the base href value in the HTML file for local server usage
# For macOS, use sed with an empty string for -i (in-place edit)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's|<base href="/[^"]*/">|<base href="./">|' "$FILE"
# For Linux, use sed with just -i (in-place edit)
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sed -i 's|<base href="/[^"]*/">|<base href="./">|' "$FILE"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Open the URL in Google Chrome in incognito mode
# Use 'open' command for macOS, 'xdg-open' for Linux
if command -v open &> /dev/null; then
    open -na "Google Chrome" --args --incognito "http://localhost:8000"
elif command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:8000"
else
    echo "Could not detect a method to open the URL. Please open your browser manually and navigate to http://localhost:8000"
fi

# Start the local web server
echo "Starting the server..."
python3 -m http.server -d build/web/
