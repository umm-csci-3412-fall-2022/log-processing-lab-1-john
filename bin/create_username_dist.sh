#!/bin/bash

# Rename the input directory parameter to inputDirectory
inputDirectory="$1"

# Extract the contents from all instances of 'failed_login_data.txt' from the input directory
# and get just the usernames, and dump it into a temporary file
tempFile=$(mktemp)

cat "$inputDirectory"/*/failed_login_data.txt | sed -n -E "s/^[A-Za-z]* [0-9]{1,2} [0-9]{2} ([A-Za-z0-9_-]*) .*$/\1/p" > "$tempFile"

# Sort the temporary file by username, then extract the counts for each username with the uniq command

sort "$tempFile" | uniq -c > testFile.txt
