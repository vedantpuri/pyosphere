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
  echo "Preparing test.."
}

# Parse provided user arguments
parse_args() {
  case "$@" in
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
    case "${provided_project_size}" in
      "small")
      project_size="small"
      ;;
      "medium")
      project_size="medium"
      ;;
      "large")
      project_size="large"
      ;;
      *)
      echo "Invalid project size provided."
      print_usage
      exit
      ;;
    esac
    prepare_test
    ;;
    "")
    prepare_test
    ;;
    *)
    echo "Invalid argument."
    print_usage
  esac
}

parse_args "$@"
