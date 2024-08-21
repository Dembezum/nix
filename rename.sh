#!/bin/bash

# Create the new directory structure
mkdir -p modules/user
mkdir -p modules/system

# Move user modules
for dir in user/modules/*; do
  if [ -d "$dir" ]; then
    mv "$dir" modules/user/
  fi
done

# Move system modules
for dir in system/modules/*; do
  if [ -d "$dir" ]; then
    mv "$dir" modules/system/
  fi
done

# Remove old directories if empty
rmdir user/modules
rmdir user
rmdir system/modules
rmdir system

echo "Directories have been reorganized successfully!"

