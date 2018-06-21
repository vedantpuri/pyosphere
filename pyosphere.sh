#!/bin/bash
# pyosphere.sh
# Author(s): Vedant Puri
# Contributer(s): Mayank Kumar
# Version: 1.0.0
# Options: -v | --version, -h | --help, -cf= | --config-file=, -cl | --clean, -i | --init

# ----- ENVIRONMENT & CONSOLE

# Console text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Script information
script_version="1.0.0"

# Environment information with defaults
pyosphere_config="pyosphere.config"
python="python"
run_source=""
project_path="$(pwd)"
pyosphere_dir="pyosphere/"
always_clean=false

# ----- SCRIPT SUPPORT

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print pyosphere.sh usage
print_usage() {
  echo "Usage: ${bold}./pyosphere.sh${normal} [-v|--version] [-h|--help] [-cf=|--config-file=] [-cl|--clean] [-i|--init]
  where:
  ${underline}-v${normal}    Prints script version
  ${underline}-h${normal}    Prints script usage
  ${underline}-cf=${normal}  Executes with specified config file (default = ${bold}pyosphere.config${normal})
  ${underline}-cl${normal}   Clean current working directory
  ${underline}-i${normal}    Initialize pyosphere for project

  ${bold}pyosphere.config${normal} Options:
  ${underline}python${normal}         Specify python binary/command (default = ${bold}python${normal})
  ${underline}run_source${normal}     Specify python binary/command
  ${underline}project_path${normal}   Specify python project path (default = ${bold}pwd${normal})
  ${underline}always_clean${normal}   Specify clean settings for incremental builds (default = ${bold}false${normal})"
}

# ----- PYOSPHERE CONFIGURATION MANAGEMENT

# Assigned: @mayankk2308
# Manage relative paths
# manage_relative_project_path() {
#   # Modify $project_path as necessary
# }

# Assigned: @vedantpuri
# Manage pyosphere configurations
# parse_pyosphere_config() {
#   # parse $pyosphere_config
#   # update $python, $run_source, $project_path, & $always_clean as necessary
#   # call manage_relative_project_path to re-evaluate $project_path if needed
#   # handle errors in config here
# }

# Assigned: @mayankk2308
# Auto-generate pyosphere configurations
# generate_pyosphere_config() {
#   # provide user-interactive pyosphere config generation
#   # alternatively just generate config file and let user fill it manually
# }

# ----- PYOSPHERE PROJECT MANAGEMENT

# Assigned: @vedantpuri
# Execute provided run source
# Do everything except execute if $run_source not provided
# execute() {
#   # execute $run_source once links have been generated
# }

# Assigned: @vedantpuri
# Prune symbolic links for incremental builds
# prune_symbolic_links() {
#   # Handle deleted links, etc.
# }

# Accumulate symbolic links for all .py files
generate_symbolic_links() {
  find "${project_path}" -name "*.py" | while read path
  do
    ln "${path}" "${pyosphere_dir}$(basename "${path}")"
  done
}

# Assigned: @mayankk2308
# Clean project
clean() {
  if [[ -d "${pyosphere_dir}" ]]
  then
    rm -r "${pyosphere_dir}"
    echo "Clean successful."
  else
    echo "Nothing to clean."
  fi
}

# ----- PYOSPHERE CONTROL FLOW

# Assigned: @vedantpuri
# Start pyosphere with environment set
# begin_execution() {
#   # Execute necessary functions with environment settings
#   # All functions are argument-free (excluding parse_args)
#   # Print all issues + number of issues encountered
#   ### Examples:
#   ###         1 Issue:
#   ###           - pyosphere.config not found
#
#   ###         2 Issues:
#   ###           - Specified python binary not found
#   ###           - Could not find any python files
# }

# Assigned: @mayankk2308
# Parse script arguments
parse_args() {
  case "${@}" in
    -v|--version)
    print_version
    ;;
    -h|--help)
    print_usage
    ;;
    -cl|--clean)
    clean
    ;;
    -i|--init)
    # generate_pyosphere_config
    ;;
    -cf=*|--config-file=*|"")
    local config_file="${@#*=}"
    if [[ ! -z "${config_file}" ]]
    then
      pyosphere_config="${config_file}"
    fi
    # begin_execution
    ;;
    *)
    echo "Invalid argument."
    print_usage
    ;;
  esac
}

parse_args "${@}"
