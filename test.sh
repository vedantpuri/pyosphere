#!/bin/bash

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
test_dir="tests/"

# Test information
project_size=""
output="/dev/stdout"
pyosphere_config="pyosphere.config"

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
    if [[ "$1" != "-s" ]]
    then
      echo "Test files have been removed sucessfully."
    fi
  else
    if [[ "$1" != "-s" ]]
    then
      echo "Test directory not found. No action required."
    fi
  fi
}

# Auto-generate test libraries with provided args
generate_test_files() {
  local folder_name="${1}"
  local file_prefix="${2}"
  local file_count="${3}"
  local file_var_count="${4}"
  local file_func_count="${5}"
  local nest_level="${6}"
  local base_path="${test_dir}${folder_name}/"
  mkdir -p "${base_path}"
  for (( file_num=1; file_num<="${file_count}"; file_num++ ))
  do
    local nests=0
    local folder_value=""
    local nested_path="${base_path}"
    if [[ "${nest_level}" != 0 ]]
    then
      nests="$(( $RANDOM % $nest_level + 1 ))"
    fi
    if [[ "$(( $RANDOM % 2 ))" == 1 ]]
    then
      folder_value="${file_num}"
    fi
    for (( depth=1; depth<=nests; depth++ ))
    do
      nested_path="${nested_path}${file_prefix}${folder_value}_internal_${depth}/"
    done
    mkdir -p "${nested_path}"
    local program_file="${nested_path}/${file_prefix}${file_num}.py"
    touch "${program_file}"
    for (( value_num=1; value_num<="${file_var_count}"; value_num++ ))
    do
      echo "${file_prefix}${file_num}_value${value_num} = ${value_num}" >> "${program_file}"
    done
    for (( func_num=1; func_num<="${file_func_count}"; func_num++ ))
    do
      echo "\n" >> "${program_file}"
      echo "def ${file_prefix}${file_num}_func${func_num}():\n\tprint(\"Inside func${func_num}\")" >> "${program_file}"
    done
    echo "\n" >> "${program_file}"
  done
}

# Prepare small, medium (default), or large test
prepare_test() {
  case "${1}" in
    "small")
    echo "${bold}Preparing small test..${normal}"
    generate_test_files "Libraries" "lib" 3 3 3 1
    generate_test_files "Sources" "main" 1 0 0 0
    local main_program="from lib1 import lib1_value1\nimport lib2\nprint(lib1_value1)\nlib2.lib2_func1()"
    echo "${main_program}" > "${test_dir}Sources/main1.py"
    echo "Small test generated."
    ;;
    ""|"medium")
    echo "${bold}Preparing medium test..${normal}"
    generate_test_files "Libraries" "lib" 20 5 5 5
    generate_test_files "Sources" "main" 1 0 0 0
    local main_program="from lib7 import lib7_value4\nimport lib19\nprint(lib7_value4)\nlib19.lib19_func5()"
    echo "${main_program}" > "${test_dir}Sources/main1.py"
    echo "Medium test generated."
    ;;
    "large")
    echo "${bold}Preparing large test..${normal}"
    generate_test_files "Libraries" "lib" 100 20 20 10
    generate_test_files "Sources" "main" 1 0 0 0
    local main_program="from lib97 import lib97_value20\nimport lib58\nprint(lib97_value20)\nlib58.lib19_func7()"
    echo "${main_program}" > "${test_dir}Sources/main1.py"
    echo "Large test generated."
    ;;
    *)
    echo "Invalid project size provided."
    print_usage
    exit
    ;;
  esac
}

# ----- CONFIG TESTING

# Generates specific config file according to test case
generate_test_config() {
  local python_bin="${1}"
  local given_run_source="${2}"
  local given_project_path="${3}"
  local always_prune_pref="${4}"
  echo "${bold}Generating pyosphere configuration...${normal}" > "${output}"
  touch "${pyosphere_config}"
  > "${pyosphere_config}"
  echo -e "#!/bin/bash\n" >> "${pyosphere_config}"
  echo -e "python=\"${python_bin}\"" >> "${pyosphere_config}"
  echo -e "run_source=\"${given_run_source}\"" >> "${pyosphere_config}"
  echo -e "project_path=\"${given_project_path}\"" >> "${pyosphere_config}"
  echo -e "always_prune=${always_prune_pref}" >> "${pyosphere_config}"
  echo "Configuration generated." > "${output}"
}

# Destroys Config file for specific test case
destroy_test_config() {
  echo "Destroying ${1}..."
  rm "${pyosphere_config}"
  echo "Destruction complete."
}

# Test cases for python binary
test_incorrect_python() {
  # Incorrect spelling
  local python="pythn"
  local run_source="${test_dir}Sources/main1.py"
  local project_path="${test_dir}"
  local pruning_pref=false
  generate_test_config "${python}" "${run_source}" "${project_path}" "${pruning_pref}"
  # TODO: Perform Check
  destroy_test_config "test_incorrect_python: Incorrect spelling"

  # Incorrect spelling with space
  python="pyth n"
  generate_test_config "${python}" "${run_source}" "${project_path}" "${pruning_pref}"
  # TODO: Perform Check
  destroy_test_config "test_incorrect_python: Incorrect spelling with space"

  # Empty String
  python=""
  generate_test_config "${python}" "${run_source}" "${project_path}" "${pruning_pref}"
  # TODO: Perform Check
  destroy_test_config "test_incorrect_python: Empty String"

  # Some other binary
  python="java"
  generate_test_config "${python}" "${run_source}" "${project_path}" "${pruning_pref}"
  # TODO: Perform Check
  destroy_test_config "test_incorrect_python: Non-python binary"

  # Random String
  python="#4829394"
  generate_test_config "${python}" "${run_source}" "${project_path}" "${pruning_pref}"
  # TODO: Perform Check
  destroy_test_config "test_incorrect_python: Random string"
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
    -ps=*|--project-size=*|"")
    delete_tests -s
    prepare_test "${@#*=}"
    ;;
    *)
    echo "Invalid argument."
    print_usage
  esac
}

parse_args "${@}"
# test_incorrect_python
