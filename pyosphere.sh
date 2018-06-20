#!/bin/sh
# pyosphere.sh
# Author(s): Vedant Puri
# Contributer(s): Mayank Kumar
# Version: 1.0.0
# Atom -> Tab Indent Level: 2

# Creates symbolic links for all .py files and collects them within a single directory
accumulate_files() {  
  mkdir -p pyosphere
  # find "${1}" -name "*.txt" | while read path;
  for path in $(find "${1}" -name "*.py");
  do
    fname=$(basename "${path}")
    $(ln -s "${path}" "pyosphere/${fname}" )
  done
}
