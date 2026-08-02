# Use the directory name argument provided to the script
# If the directory name is not provided to the script, exit with 1
# If the directory does not exist, exit with 2
# If the directory is empty, exit with 3
# file_count will contain the number of files in the provided directory

#!/bin/bash

directory="$1"

# Check if directory name is provided
# if [ -z "directory" ]; then # this doesn't work
if [ $# -eq 0 ]; then
 exit 1
fi

# Check if directory exists
if [ ! -d "$directory" ]; then
    exit 2
fi

# Check if directory is empty
if [ -z "$(ls -A "$directory")" ]; then
    exit 3
fi

# Count the number of files in the $directory
file_count=$(ls -1 "$directory" | wc -l)
