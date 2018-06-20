#!/bin/sh

# test.sh
# Author(s): Mayank Kumar (@mayankk2308, github.com)
# License: Specified in LICENSE.md
# Version: 1.0.0
# Options: -v | --version, -d | --delete, -ps | --project-size, -h | --help

# Console text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Script information
script_version="1.0.0"
test_dir="Tests/"

# Test information
project_size=""

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print test.sh usage
print_usage() {
  echo "Usage: ${bold}./test.sh${normal} [-v|--version] [-d|--delete] [-ps|--project-size] [-h|--help]
  where:
  ${underline}-v${normal}   Prints script version.
  ${underline}-d${normal}   Deletes generated test files and folders.
  ${underline}-ps${normal}  Specifies project size [small/medium (default)/large].
  ${underline}-h${normal}   Prints script usage."
}

# Delete any test files/folders
delete_tests() {
  if [[ -d "${test_dir}" ]]
  then
    rm -r "${test_dir}"
    echo "Test files have been removed sucessfully."
  else
    echo "Test directory not found. No action required."
  fi
}

# Prepare test
prepare_test() {
  case "${1}" in
    "small")
    echo "${bold}Preparing small test..${normal}"
    mkdir -p "${test_dir}Sources/" "${test_dir}Libraries/"
    touch "${test_dir}Libraries/lib1.py" "${test_dir}Libraries/lib2.py" "${test_dir}Sources/main.py"
    echo "lib1_value = 1" > "${test_dir}Libraries/lib1.py"
    echo "lib2_value = 2" > "${test_dir}Libraries/lib2.py"
    local main_program="from lib1 import lib1_value\nfrom lib2 import lib2_value\nprint(lib1_value)\nprint(lib2_value)"
    echo "${main_program}" > "${test_dir}Sources/main.py"
    ;;
    ""|"medium")
    echo "${bold}Preparing medium test..${normal}"
    mkdir -p "${test_dir}Sources/" "${test_dir}Libraries/"
    ;;
    "large")
    echo "${bold}Preparing large test..${normal}"
    mkdir -p "${test_dir}Sources/" "${test_dir}Libraries/"
    ;;
    *)
    echo "Invalid project size provided."
    print_usage
    exit
    ;;
  esac
  echo "Test generation complete."
}

# Parse provided user arguments
parse_args() {
  case "${@}" in
    -v|--version)
    print_version
    ;;
    -d|--delete)
    delete_tests
    ;;
    -h|--help)
    print_usage
    ;;
    -ps=*|--project-size=*)
    local provided_project_size="${@#*=}"
    prepare_test "${@#*=}"
    ;;
    "")
    prepare_test
    ;;
    *)
    echo "Invalid argument."
    print_usage
  esac
}

parse_args "${@}"
