# Check if exactly two arguments are provided.
# Output "provide two numbers" if the number of arguments is not 2 and exit with 1
# Calculate the sum of the two numbers
# Output "positive" if the sum is positive
# Output "negative" if the sum is negative
# Output "zero" if the sum is zero

# Assume the script will only ever receive two numbers as arguments.
# you do not need to handle cases where the input is not a number

#!/bin/bash

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "provide two numbers"
    exit 1
fi

# Calculate the sum
sum=$(( $1 + $2 ))

# Determine whether the sum is positive, negative or zero
if [ "$sum" -gt 0 ]; then
    echo "positive"
elif [ "$sum" -lt 0 ]; then
    echo "negative"
else
    echo "zero"
fi
