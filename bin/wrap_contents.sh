#!/bin/bash

# Rename the input parameters into helpfully named variables
fileContents="$1"
headerFooterFileBaseName="$2"
targetFileName="$3"

# Concatenate the files based on the parameters
# This should concatenate the header, then the contents, then the footer
# outputting into the desired target file
cat "${headerFooterFileBaseName}_header.html" "$fileContents" "${headerFooterFileBaseName}_footer.html" > "$targetFileName"
