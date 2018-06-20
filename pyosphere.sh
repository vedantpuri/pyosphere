#!/bin/sh
# pyosphere.sh
# Author(s): Vedant Puri
# Contributer(s): Mayank Kumar
# Version: 1.0.0
# Atom -> Tab Indent Level: 2

accumulate_files() {
  $(mkdir pyosphere)
  find $(pwd) -name "*.py" | while read path; do
    fname=$(basename "$path")
    $(ln -s "$path" "pyosphere/$fname" )
  done
}

# collect_directory_paths()
# {
#   for file in "$1"/*
#   do
#     if [[ -d "$file" ]]
#     then
#       echo "$file"
#       get_last_internal_nodes "$file"
#     fi
#   done
# }
#
# collect_directory_paths "."
