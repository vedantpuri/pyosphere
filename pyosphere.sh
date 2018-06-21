#!/bin/sh
# pyosphere.sh
# Author(s): Vedant Puri
# Contributer(s): Mayank Kumar
# Version: 1.0.0
# Options: -v | --version, -pv | --python-version, -pp | --project-path, -ef | --execution-file, -cb | --clean-build, -cl | --clear,  -h | --help

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
  for path in $(find "${1}" -name "*.py")
  do
    ln -s "${path}" "pyosphere/$(basename "${path}")"
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

check_concurrent_args() {
  if [[ "${1}" != 0 ]]
  then
    echo "Invalid combination of arguments."
    # print_usage
    exit
  fi
}

# Parse provided user arguments and sets variables
parse_args() {
  local concurrent_arg=0
  for arg in "$@"
  do
  case "${arg}" in
    -v|--version)
    check_concurrent_args "${concurrent_arg}"
    print_version
    ;;
    -h|--help)
    check_concurrent_args "${concurrent_arg}"
    echo "help"
    # print_usage
    ;;
    -pp=*|--project-path=*)
    # Need better control flow. Why call a crucial process within arg parsing?
    accumulate_files "${arg#*=}"
    (( concurrent_arg++ ))
    ;;
    -ef=*|--execution-file=*)
    execution_file="${arg#*=}"
    (( concurrent_arg++ ))
    ;;
    -pv=*|--python-version=*)
    python_version="${arg#*=}"
    (( concurrent_arg++ ))
    ;;
    -cl|--clear)
    check_concurrent_args "${concurrent_arg}"
    # destructor
    ;;
    -cb|--clean-build)
    check_concurrent_args "${concurrent_arg}"
    # perform_clean_build
    ;;
    *)
    echo "Invalid argument."
    # print_usage
  esac
  # start run here for set configuration
  done
}

parse_args "${@}"
# echo "${pyosphere_location}"
# $(rm -r "pyosphere")
