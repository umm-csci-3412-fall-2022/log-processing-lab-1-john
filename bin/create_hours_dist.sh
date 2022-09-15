#!/bin/bash

# Rename the input directory to 'inputDirectory'
inputDirectory="$1"

# Extract the contents from all instances of 'failed_login_data.txt' from the input directory
# and get the hours, and dump it into a temporary file.
tempFile=$(mktemp)

cat "$inputDirectory"/*/failed_login_data.txt | sed -n -E "s/^[A-Za-z]* [0-9]{1,2} ([0-9]{2}).*$/\1/p" > "$tempFile"

# Sort the temporary file by hour, then extract counts for each hour with the 'uniq' command
# Then pipe the counted and sorted output into a sed command to generate a JS body for the final output
# Lastly pipe the output of the sed command into a wrap_contents call
sort "$tempFile" | uniq -c | sed -n -E "s/^[ ]+([0-9]+) ([0-9]{1,2})$/data.addRow(['\2', \1]);/p" | bin/wrap_contents.sh /dev/stdin html_components/hours_dist "$inputDirectory"/hours_dist.html
