#!/bin/bash

# Rename the input directory
targetDirectory="$1"

# Collect all the data from the files within the directory
# assuming that the directory has the structure /var/log/*

# Then we pipe it into a sed command to match all lines that have a failed login
# extracting the columns we want in groups
# Finally, we pipe the output into the desired output file
cat "$targetDirectory"/var/log/* | sed -n -E "s/^([A-Za-z]*)[ ]{1,2}([0-9]{1,2}) ([0-9]{2}):[0-9]{2}:[0-9]{2} [A-Za-z_0-9\-]* [A-Za-z]+\[[0-9]*\]: Failed password for (invalid user )?([A-Za-z0-9_\-]*) from ([0-9\.]+) port [0-9]* ssh2$/\1 \2 \3 \5 \6/p" > "$targetDirectory"/failed_login_data.txt
