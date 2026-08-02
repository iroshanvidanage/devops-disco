# Accept a file path as an argument
# Define a function named count_files
# In the function, check if the directory exists
# If the directory does not exists, exist with 1
# If the directory exists, count the number of files in the directory
# Return the number of files
# Call the function with the file path argument

#!/bin/bash

# Accept a file path as an argument
directory="$1"


# Define a function named count_files
count_files() {
    local dir="$1"

    if [ ! -d "$dir" ]; then
        exist 1
    fi

    local count
    count=$(ls -1 "$dir" | wc -l)

    return "$count"
}

count_files "$directory"

echo $?
