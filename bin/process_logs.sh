#!/bin/bash


# Collect the input files in a list, named inputFiles
inputFiles=("$@")

# Make a scratch directory to work within
tempDir=$(mktemp -d)

for logFile in "${inputFiles[@]}"
do
  # Get the base filename without extension (eg. "discovery_secure.tgz" -> "discovery")
  baseFileName="${logFile%_secure.*}"
  baseFileName=$(basename "$baseFileName")

  # Name the directory for the extracted file's destination
  logDir="$tempDir"/"$baseFileName"

  # Create the new directory so we can extract into it
  mkdir -p "$logDir"

  # Extract the contents of the file into the temporary directory
  tar -xzf "$logFile" -C "$logDir"

  bin/process_client_logs.sh "$logDir"
done

# Run the distribution creation scripts on the newly extracted data
bin/create_username_dist.sh "$tempDir"
bin/create_hours_dist.sh "$tempDir"
bin/create_country_dist.sh "$tempDir"

# Assemble the final report HTML in the scratch directory
bin/assemble_report.sh "$tempDir"

# Move the final report from the scratch directory to the current directory
mv "$tempDir"/failed_login_summary.html ./failed_login_summary.html
