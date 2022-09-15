#!/bin/bash

# Rename the input directory to 'inputDirectory'
inputDirectory="$1"

# Extract the IP addressed from all instances of 'failed_login_data.txt' from the input directory
# dumping the output into the temporary file
tempFile=$(mktemp)

cat "$inputDirectory"/*/failed_login_data.txt | sed -n -E "s/^[A-Za-z]* [0-9]{1,2} [0-9]{2} [A-Za-z0-9_-]* ([0-9.]+)$/\1/p" > "$tempFile"

# Join the IP addresses with their associated countries based on the contents of /etc/countryIPmap.txt
# Start by sorting ascending by IP string
# Then extract and count by the country using the uniq command
# Third, pipe the counted country and count data to create a JS body
# then pipe the output into a wrap_contents call.
sort "$tempFile" | join /dev/stdin etc/country_IP_map.txt | sed -n -E "s/^[0-9.]+ ([A-Z]{2})/\1/p " | sort | uniq -c | sed -n -E "s/^[ ]+([0-9]+) ([A-Z]{2})$/data.addRow(['\2', \1]);/p" | bin/wrap_contents.sh /dev/stdin html_components/country_dist "$inputDirectory"/country_dist.html
