#!/bin/bash
# pyosphere.sh
# Authors: Mayank Kumar, Vedant Puri
# Version: 1.0.0

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
given_project_path="$(pwd)/"
always_prune_pref=false
pyosphere_dir="pyosphere/"

# ----- SCRIPT SUPPORT

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print pyosphere.sh usage
print_usage() {
  echo "Usage: ${bold}./pyosphere.sh${normal} [-v|--version] [-h|--help] [-cf=|--config-file=] [-cl|--clean] [-i|--init -e=|--execute=] [-r|--reset] [-p|--prune]
  where:
  ${underline}-v${normal}        Prints script version
  ${underline}-h${normal}        Prints script usage
  ${underline}-cf=${normal}      Executes with specified config file (default = ${bold}pyosphere.config${normal})
  ${underline}-cl${normal}       Clean current working directory
  ${underline}-i${normal}        Initialize pyosphere for project
  ${underline}-i -e=${normal}    Initialize pyosphere for project
  ${underline}-r${normal}        Reset project to pre-pyosphere state
  ${underline}-p${normal}        Prune project build

  ${bold}pyosphere.config${normal} Options:
  ${underline}python${normal}         Specify python binary/command (default = ${bold}python${normal})
  ${underline}run_source${normal}     Specify python binary/command
  ${underline}project_path${normal}   Specify python project path (default = ${bold}pwd${normal})
  ${underline}always_prune${normal}   Specify pruning settings for incremental builds (default = ${bold}false${normal})"
}

# ----- PYOSPHERE CONFIGURATION MANAGEMENT

# Assigned: @vedantpuri
# Manage pyosphere configurations
parse_pyosphere_config() {
  echo "${bold}Parsing ${pyosphere_config}...${normal}"
  if [[ -f "${pyosphere_config}" ]]
  then
    source "${pyosphere_config}"
  else
    echo "Pyosphere configuration not available. Using defaults."
    return
  fi
  echo "${bold}Fetching project...${normal}"
  if [[ -z "${project_path}" ]]
  then
    echo "Path not provided. Using current working directory."
  elif [[ ! -d "${project_path}" ]]
  then
    echo "Project directory does not exist. Re-check configuration."
    exit
  else
    given_project_path="${project_path}"
    [[ "${given_project_path:-1}" != "/" ]] && given_project_path="${given_project_path}/"
    echo "Project fetched."
  fi
  if [[ ! -z "${run_source}" ]]
  then
    echo "${bold}Setting execution script...${normal}"
    given_run_source="${run_source}"
    echo "Script set."
  fi
  echo "${bold}Setting python binary...${normal}"
  full_python_bin_path="$(which "${python}")"
  if [[ ! -z "${full_python_bin_path}" ]]
  then
    python_bin="${full_python_bin_path}"
    echo "Binary set."
  else
    echo "Binary not provided or invalid. Using ${underline}python${normal}."
  fi
  echo "${bold}Checking pruning preferences...${normal}"
  if [[ "${always_prune}" == true ]]
  then
    always_prune_pref=true
    echo "Pruned builds enabled."
  else
    echo "Pruned builds disabled."
  fi
  echo "Parse complete."

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
  echo -e "always_prune=${always_prune_pref}" >> "${pyosphere_config}"
  echo "Configuration generated."
}

# ----- PYOSPHERE PROJECT MANAGEMENT

# Assigned: @vedantpuri
# Execute provided run source
# Do everything except execute if $run_source not provided
execute() {
#   # Execute $given_run_source once links have been generated
#   # Check if $given_run_source belongs to $given_project_path
  file_count=$(find "${given_project_path}" -name "${given_run_source}" | wc -l)
  if [[ $file_count -eq 0 ]]
  then
    echo "Error: "$(basename "${given_run_source}")" No such file found in ${given_project_path}"
    exit
  elif [[ $file_count -gt 1 ]]
  then
    echo "Error: Multiple instances of ${given_run_source} detected. Resolve ambiguity and Re-configure using absolute path."
    exit
  fi
  echo "${bold}Running ${given_run_source}...${normal}"
  command_to_run="${python_bin} ${given_run_source}"
  $command_to_run
  echo "Execution complete."

}

# Assigned: @vedantpuri
# Prune .pyc for incremental builds
prune_pyc() {
  echo "${bold}Pruning '.pyc' files...${normal}"
  if [[ ! -d "${pyosphere_dir}" ]]
  then
    echo "Pyosphere build not found. Cannot prune."
    return
  fi
  for file in "${pyosphere_location}"*.pyc
  do
    [[ ! -f "${file}" ]] && continue
    rm "${file}"
  done
  echo "Pruning complete."
}


# Assigned: @vedantpuri
# Prune hard links for incremental builds
prune_hard_links() {
  # local pyosphere_location="${given_project_path}${pyosphere_dir}"

  # TODO: Prune .pyc files

  echo "${bold}Pruning hard links...${normal}"
  if [[ ! -d "${pyosphere_dir}" ]]
  then
    echo "Pyosphere build not found. Cannot prune."
    return
  fi
  for file in "${pyosphere_location}"*.py
  do
    [[ ! -f "${file}" ]] && continue
    local alias_file="${pyosphere_location}.$(basename ${file}).alias"
    [[ -e "${alias_file}" ]] && continue
    rm "${alias_file}"
    rm "${file}"
  done
  echo "Pruning complete."
}

# Generate hard links for all .py files
generate_hard_links() {
  echo "${bold}Generating build files...${normal}"
  if [[ -z "$(find "${given_project_path}" -name "*.py")" ]]
  then
    echo "Empty Directory/ No '.py' files detected: No files to generate"
    return
  fi
  
  find "${given_project_path}" -name "*.py" | while read path
  do
    local base_name="$(basename "${path}")"
    local hard_link_path="${pyosphere_dir}${base_name}"
    local sym_link_path="${pyosphere_dir}.${base_name}.alias"
    [[ ! -f "${hard_link_path}" ]] && ln "${path}" "${hard_link_path}"
    [[ ! -L "${sym_link_path}" ]] && ln -s "${path}" "${sym_link_path}"
  done
  echo "Build generated."
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
  echo "${bold}Resetting...${normal}"
  clean
  [[ -f "${pyosphere_config}" ]] && rm "${pyosphere_config}"
  echo "Reset complete."
}

# ----- PYOSPHERE CONTROL FLOW

# Assigned: @vedantpuri
# Start pyosphere with environment set
begin_execution() {
#   # Execute necessary functions with environment settings
#   # All functions are argument-free (excluding parse_args)
#   # Print all issues + number of issues encountered

  # Parses config file + performs necessary sanity checks.
  parse_pyosphere_config

  # Assuming given_project_path ends with a '/'.
  pyosphere_dir="${given_project_path}${pyosphere_dir}"
  mkdir -p "${pyosphere_dir}"

  # Generates hard links for files + performs necessary sanity checks.
  # Will this be done everytime ?
  generate_hard_links

  # Prunes hard links if necessary
  if [[ "${always_prune_pref}" == true ]]
  then
    prune_hard_links
  fi

  # execute
}

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
    -p|--prune)
    prune_hard_links
    ;;
    -cf=*|--config-file=*|"")
    local config_file="${@#*=}"
    [[ ! -z "${config_file}" ]] && pyosphere_config="${config_file}"
    if [[ "${@}" != "" ]]
    then
      echo "No configuration file provided. Run with ${underline}-h${normal} for help."
      return
    fi
    # for testing only
    ## generate_hard_links
    ## parse_pyosphere_config

    # begin_execution
    ;;
    *)
    echo "Invalid argument. Run with ${underline}-h${normal} for help."
    ;;
  esac
}

parse_args "${@}"
