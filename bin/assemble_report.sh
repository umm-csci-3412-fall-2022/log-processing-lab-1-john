#!/bin/bash

# Rename the input directory to 'inputDirectory'
inputDirectory="$1"

# Concatenate the three report html files from the input directory
cat "$inputDirectory"/*_dist.html | bin/wrap_contents.sh /dev/stdin html_components/summary_plots "$inputDirectory"/failed_login_summary.html

