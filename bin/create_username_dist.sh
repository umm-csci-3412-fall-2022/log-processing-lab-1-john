#!/bin/bash

# Rename the input directory parameter to inputDirectory
inputDirectory="$1"

# Extract the contents from all instances of 'failed_login_data.txt' from the input directory
# and get just the usernames, and dump it into a temporary file
tempFile=$(mktemp)

cat "$inputDirectory"/*/failed_login_data.txt | sed -n -E "s/^[A-Za-z]* [0-9]{1,2} [0-9]{2} ([A-Za-z0-9_-]*) .*$/\1/p" > "$tempFile"

# Sort the temporary file by username, then extract the counts for each username with the uniq command
# Then it pipes that counted and sorted output into a sed command which creates the javascript body for the final output.
# Lastly, pipe the output of the sed command into a wrap_contents call.
sort "$tempFile" | uniq -c | sed -n -E "s/^[ ]+([0-9]+) ([A-Za-z0-9_-]*)$/data.addRow(['\2', \1]);/p" | bin/wrap_contents.sh /dev/stdin html_components/username_dist username_dist.html
