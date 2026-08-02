# Use a loop and wildcards to count the number of txt, jog, and png files
# The script should run without an argument provided
# The final output should be a string matching the following format, including spaces:

#!/bin/bash

txt_count=0
jpg_count=0
png_count=0

for file in *; do
    case "$file" in
        *.txt) ((txt_count++)) ;;
        *.jpg) ((jpg_count++)) ;;
        *.png) ((png_count++)) ;;
    esac
done

total=$((txt_count + jpg_count + png_count))
echo "$txt_count, $jpg_count, $png_count, $total"
