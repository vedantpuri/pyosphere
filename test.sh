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

# Auto-generate test libraries with provided args
generate_test_files() {
  local folder_name="${1}"
  local file_prefix="${2}"
  local file_count="${3}"
  local file_var_count="${4}"
  local file_func_count="${5}"
  local program_file=""
  mkdir -p "${test_dir}${folder_name}/"
  for (( file_num=1; file_num<="${file_count}"; file_num++ ))
  do
    program_file="${test_dir}${folder_name}/${file_prefix}${file_num}.py"
    touch "${program_file}"
    > "${program_file}"
    for (( value_num=1; value_num<="${file_var_count}"; value_num++ ))
    do
      echo "${file_prefix}${file_num}_value${value_num} = ${value_num}" >> "${program_file}"
    done
    for (( func_num=1; func_num<="${file_func_count}"; func_num++ ))
    do
      echo "\n" >> "${program_file}"
      echo "def ${file_prefix}${file_num}_func${func_num}:\n\tprint(\"Inside func${func_num}\")" >> "${program_file}"
    done
    echo "\n" >> "${program_file}"
  done
}

# Prepare small, medium (default), or large test
prepare_test() {
  case "${1}" in
    "small")
    echo "${bold}Preparing small test..${normal}"
    generate_test_files "Libraries" "lib" 3 3 3
    generate_test_files "Sources" "main" 1 0 0
    local main_program="from lib1 import lib1_value\nimport lib2\nprint(lib1_value)\nlib2.lib2_func1()"
    echo "${main_program}" > "${test_dir}Sources/main1.py"
    echo "Small test generated."
    ;;
    ""|"medium")
    echo "${bold}Preparing medium test..${normal}"
    echo "Medium test generated."
    ;;
    "large")
    echo "${bold}Preparing large test..${normal}"
    mkdir -p "${test_dir}Sources/" "${test_dir}Libraries/"
    echo "Large test generated."
    ;;
    *)
    echo "Invalid project size provided."
    print_usage
    exit
    ;;
  esac
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
