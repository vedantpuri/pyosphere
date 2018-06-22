#!/bin/bash
# pyosphere.sh
# Author(s): Vedant Puri
# Contributer(s): Mayank Kumar
# Version: 1.0.0
# Options: -v | --version, -h | --help, -cf= | --config-file=, -cl | --clean, -i | --init -e= | --execute=, -r | --reset

# ----- ENVIRONMENT & CONSOLE

# Console text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Script information
script_version="1.0.0"

# Environment information with defaults
pyosphere_config="pyosphere.config"
python_bin="python"
given_run_source=""
given_project_path="$(pwd)"
always_clean_pref=false
pyosphere_dir="pyosphere/"

# ----- SCRIPT SUPPORT

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print pyosphere.sh usage
print_usage() {
  echo "Usage: ${bold}./pyosphere.sh${normal} [-v|--version] [-h|--help] [-cf=|--config-file=] [-cl|--clean] [-i|--init -e=|--execute=] [-r|--reset]
  where:
  ${underline}-v${normal}        Prints script version
  ${underline}-h${normal}        Prints script usage
  ${underline}-cf=${normal}      Executes with specified config file (default = ${bold}pyosphere.config${normal})
  ${underline}-cl${normal}       Clean current working directory
  ${underline}-i${normal}        Initialize pyosphere for project
  ${underline}-i -e=${normal}    Initialize pyosphere for project
  ${underline}-r${normal}        Reset project to pre-pyosphere state

  ${bold}pyosphere.config${normal} Options:
  ${underline}python${normal}         Specify python binary/command (default = ${bold}python${normal})
  ${underline}run_source${normal}     Specify python binary/command
  ${underline}project_path${normal}   Specify python project path (default = ${bold}pwd${normal})
  ${underline}always_clean${normal}   Specify clean settings for incremental builds (default = ${bold}false${normal})"
}

# ----- PYOSPHERE CONFIGURATION MANAGEMENT

# Assigned: @vedantpuri
# Manage pyosphere configurations - can likely source $pyosphere_config
parse_pyosphere_config() {
#   # parse $pyosphere_config
#   # update $python, $run_source, $project_path, & $always_clean as necessary
#   # call manage_relative_project_path to re-evaluate $project_path if needed
#   # handle errors in config here

  echo "Parsing ${pyosphere_config} ..."
  
  # Import variables
  source "${pyosphere_config}"

  # Check if Project path exists
  # Assuming absolute path provided
  if [[ -de "${project_path}" ]]
  then
    given_project_path="${project_path}"
  else
    echo "Project path doesn't exist/ Incorrect path provided/ Absolute path not provided. Re-check pyosphere.config"
    exit
  fi

  # Check if the file to be executed exists
  # Assuming absolute path provided
  if [[ -e "${run_source}" ]]
  then
    given_run_source="${run_source}"
  else
    echo "File doesn't exist/ Incorrect path provided/ Absolute path not provided. Re-check pyosphere.config."
    exit
  fi

  # Check if Python binary provided exists
  count="$(compgen -c | grep -Fx "${python}" | wc -l)"
  if [[ "${count}" -gt 0 ]]
  then
    python_bin="${python}"
  else
    echo "Python binary doesn't exist/ Incorrect binary provided. Re-check pyosphere.config."
    exit
  fi

  # Check if `always_clean` is a boolean
  if [[ "${always_clean}" == true || "${always_clean}" == false ]]
  then
    always_clean_pref="${always_clean}"
  else
    echo "Invalid type for 'always_clean. Re-check pyosphere.config."
    exit
  fi

  echo "Successfully parsed ${pyosphere_config}."

}

# Assigned: @mayankk2308
# Auto-generate pyosphere configurations
generate_pyosphere_config() {
  echo "${bold}Generating pyosphere configuration...${normal}"
  touch "${pyosphere_config}"
  > "${pyosphere_config}"
  echo -e "#!/bin/bash\n" >> "${pyosphere_config}"
  echo -e "python=\"${python_bin}\"" >> "${pyosphere_config}"
  echo -e "run_source=\"${given_run_source}\"" >> "${pyosphere_config}"
  echo -e "project_path=\"${given_project_path}\"" >> "${pyosphere_config}"
  echo -e "always_clean=${always_clean_pref}" >> "${pyosphere_config}"
  echo "Configuration generated."
}

# ----- PYOSPHERE PROJECT MANAGEMENT

# Assigned: @vedantpuri
# Execute provided run source
# Do everything except execute if $run_source not provided
# execute() {
#   # execute $run_source once links have been generated
# }

# Assigned: @vedantpuri
# Prune hard links for incremental builds
prune_hard_links() {
  # Handle deleted links
  if [[ "${given_project_path: -1}" == "/" ]]
  then
    local pyosphere_location="${given_project_path}${pyosphere_dir}"
  else
    local pyosphere_location="${given_project_path}/${pyosphere_dir}"
  fi
  echo "${bold}Pruning hard links...${normal}"
  for file in "${pyosphere_location}"*.py
  do
      local num_hard_links="$(stat -l "${file}" | cut -d' ' -f2)"
      if [[ $num_hard_links -eq 1 ]]
      then
        rm "${$file}"
      fi
  done
  echo "Pruning complete."
}

# Generate hard links for all .py files
generate_hard_links() {
  find "${given_project_path}" -name "*.py" | while read path
  do
    ln "${path}" "${pyosphere_dir}$(basename "${path}")"
  done
}

# Assigned: @mayankk2308
# Clean project
clean() {
  if [[ -d "${pyosphere_dir}" ]]
  then
    echo "${bold}Cleaning...${normal}"
    rm -r "${pyosphere_dir}"
    echo "Clean successful."
  else
    echo "Nothing to clean."
  fi
}

# Assigned: @mayankk2308
# Reset project
reset() {
  clean
  if [[ -f "${pyosphere_config}" ]]
  then
    echo "${bold}Resetting...${normal}"
    rm "${pyosphere_config}"
    echo "Reset complete."
  else
    echo "No configuration file detected. Procedure complete."
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
    -i|--init|"-i -e="*|"--init -e="*|"-i --execute="*|"--init --execute="*)
    # Could improve?
    given_run_source="$(echo "${@#*=}" | awk '{ print $2 }')"
    if [[ "${@}" != "-i" && "${@}" != "--init" && -z "${given_run_source}" ]]
    then
      echo "No execution file provided. Run with ${underline}-h${normal} for help."
      return
    fi
    generate_pyosphere_config
    ;;
    -r|--reset)
    reset
    ;;
    -cf=*|--config-file=*|"")
    local config_file="${@#*=}"
    if [[ ! -z "${config_file}" ]]
    then
      pyosphere_config="${config_file}"
    fi
    if [[ "${@}" != "" ]]
    then
      echo "No configuration file provided. Run with ${underline}-h${normal} for help."
      return
    fi
    # begin_execution
    ;;
    *)
    echo "Invalid argument. Run with ${underline}-h${normal} for help."
    ;;
  esac
}

parse_args "${@}"
