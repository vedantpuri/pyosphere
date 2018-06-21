#!/bin/sh
# pyosphere.sh
# Author(s): Vedant Puri
# Contributer(s): Mayank Kumar
# Version: 1.0.0
# Atom -> Tab Indent Level: 2
# Options: -v | --script-version, -pv | --python-version, -pp | --project-path, -ef | --execution-file, -c | --clean-build, -clr | --clear,  -h | --help

# Console text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Script information
script_version="1.0.0"

# Internal Variables
python_version="$(python -V 2>&1 | awk '{print $2}')"
pyosphere_location=""
execution_file=""

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print pyosphere.sh usage
# print_usage() {
#
# }

# Accumulates symbolic links for all .py files
accumulate_files() {
  mkdir -p pyosphere
  # pyosphere_location="${1}/pyosphere"
  for path in $(find "${1}" -name "*.py");
  do
    fname=$(basename "${path}")
    $(ln -s "${path}" "pyosphere/${fname}" )
  done
}

# Runs the requested Python file
# run_python() {
#   # Run python using python-version and mentioned file
# }

# perform_clean_build() {
#   # Calls destructor
#   # Calls accumulate_files
#   # Calls run_python
# }

# Clears Pyosphere from the project
# destructor() {
#   # Extract pyosphere_location and perform `rm -r`
# }

# Parse provided user arguments and sets variables
parse_args() {
  for arg in "$@"
  do
  case "${arg}" in
    -v|--script-version)
    print_version
    exit
    ;;
    -h|--help)
    # print_usage
    exit
    ;;
    -pp=*|--project-path=*)
    accumulate_files "${arg#*=}"
    ;;
    -ef=*|--execution-file=*)
    execution_file="${arg#*=}"
    ;;
    -pv=*|--python-version=*)
    python_version="${arg#*=}"
    ;;
    -clr|--clear)
    # destructor
    exit
    ;;
    -c|--clean-build)
    # perform_clean_build
    exit
    ;;
    *)
    echo "Invalid argument."
  esac
  # start run here for set configuration
  done
}

parse_args "${@}"
# echo "${pyosphere_location}"
# $(rm -r "pyosphere")
