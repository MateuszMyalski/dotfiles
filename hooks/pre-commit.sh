#!/bin/bash

VERSION_FILE="./dot/.version"

# Check if the version file exists
if [ -e "$VERSION_FILE" ]; then
    # Increment version number
    current_version=$(cat "$VERSION_FILE")
    new_version=$((current_version + 1))
    echo "$new_version" > "$VERSION_FILE"

    # Add the version file to the staging area
    git add "$VERSION_FILE"

    echo "Version incremented to $new_version"
else
    echo "Error: $VERSION_FILE not found"
    exit 1
fi

# Continue with the rest of the commit process
exit 0