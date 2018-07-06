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
find_command="shopt -s nullglob && find ${given_project_path} -iname \"*.py\""
pyosphere_dir="pyosphere/"
output="/dev/stdout"

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
  ${underline}-ie=${normal}       Initialize pyosphere for project with name of main .py execution source
  ${underline}-r${normal}        Reset project to pre-pyosphere state
  ${underline}-p${normal}        Prune project build

  ${bold}pyosphere.config${normal} Options:
  ${underline}python${normal}         Specify python binary/command (default = ${bold}python${normal})
  ${underline}run_source${normal}     Specify python binary/command
  ${underline}project_path${normal}   Specify python project path (default = ${bold}pwd${normal})
  ${underline}always_prune${normal}   Specify pruning settings for incremental builds (default = ${bold}false${normal})"
}

# ----- PYOSPHERE CONFIGURATION MANAGEMENT

# Manage pyosphere configurations
parse_pyosphere_config() {
  echo "${bold}Parsing ${pyosphere_config}...${normal}" > "${output}"
  if [[ -f "${pyosphere_config}" ]]
  then
    source "${pyosphere_config}"
  else
    echo "Pyosphere configuration not available. Using defaults." > "${output}"
    return
  fi
  echo "${bold}Fetching project...${normal}" > "${output}"
  if [[ -z "${project_path}" ]]
  then
    echo "Path not provided. Using current working directory." > "${output}"
  elif [[ ! -d "${project_path}" ]]
  then
    echo "Project directory does not exist. Re-check configuration." > "${output}"
    exit
  else
    given_project_path="${project_path}"
    [[ "${given_project_path: -1}" != "/" ]] && given_project_path="${given_project_path}/"
    echo "Project fetched." > "${output}"
  fi
  if [[ ! -z "${run_source}" ]]
  then
    echo "${bold}Setting execution file...${normal}" > "${output}"
    given_run_source="${run_source}"
    echo "File set." > "${output}"
  fi
  echo "${bold}Setting python binary...${normal}" > "${output}"
  full_python_bin_path="$(which "${python}")"
  if [[ ! -z "${full_python_bin_path}" && "$("${python}" --version 2>&1)" =~ "Python" ]]
  then
    python_bin="${full_python_bin_path}"
    echo "Binary set." > "${output}"
  else
    echo "Binary not provided or invalid. Using ${underline}python${normal}." > "${output}"
  fi
  echo "${bold}Checking pruning preferences...${normal}" > "${output}"
  if [[ "${always_prune}" == true ]]
  then
    always_prune_pref=true
    echo "Pruned builds enabled." > "${output}"
  else
    echo "Pruned builds disabled." > "${output}"
  fi
  if [[ -z "${resources_to_include[*]}" ]]
  then
    echo "No extra resources included." > "${output}"
  else
    echo "Including ${resources_to_include[*]}." > "${output}"
  fi
  echo "Parse complete." > "${output}"
}

# Auto-generate pyosphere configurations
generate_pyosphere_config() {
  echo "${bold}Generating pyosphere configuration...${normal}" > "${output}"
  touch "${pyosphere_config}"
  > "${pyosphere_config}"
  echo -e "#!/bin/bash\n" >> "${pyosphere_config}"
  echo -e "python=\"${python_bin}\"" >> "${pyosphere_config}"
  echo -e "run_source=\"${given_run_source}\"" >> "${pyosphere_config}"
  echo -e "project_path=\"${given_project_path}\"" >> "${pyosphere_config}"
  echo -e "always_prune=${always_prune_pref}" >> "${pyosphere_config}"
  echo -e "resources_to_include=()" >> "${pyosphere_config}"
  echo "Configuration generated." > "${output}"
}

# ----- PYOSPHERE PROJECT MANAGEMENT

# Execute provided run source
execute() {
  [[ ! -f "${pyosphere_dir}${given_run_source}" ]] && echo "Execution file not present or specified. No program run." && return
  echo "${bold}Running ${given_run_source}...${normal}" > "${output}"
  echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" > "${output}"
  "${python_bin}" -B "${pyosphere_dir}${given_run_source}"
  echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" > "${output}"
  echo "Execution complete." > "${output}"
}

# Prune hard links + '.pyc' for incremental builds
prune_build() {
  echo "${bold}Pruning build...${normal}" > "${output}"
  if [[ ! -d "${pyosphere_dir}" ]]
  then
    echo "Pyosphere build not found. Cannot prune."
    return
  fi
  for file in "${pyosphere_dir}"*.py
  do
    [[ ! -f "${file}" ]] && continue
    local alias_file="${pyosphere_dir}.$(basename ${file}).alias"
    [[ -e "${alias_file}" ]] && continue
    rm "${alias_file}"
    rm "${file}"
  done
  echo "Pruning complete." > "${output}"
}

# Find command generator
generate_find_command() {
  if [[ "${#resources_to_include[@]}" == "0" ]]
  then
    return
  fi
  for extension in ${resources_to_include[@]}
  do
    find_command+=" -o -iname \"*.${extension}\""
  done
}

# Generate hard links for all .py files
generate_build() {
  echo "${bold}Generating build files...${normal}" > "${output}"
  local is_python_project=false
  generate_find_command
  while read path
  do
    if [[ "${path: -3}" == ".py" ]]
    then
      is_python_project=true
    fi
    local base_name="$(basename "${path}")"
    local hard_link_path="${pyosphere_dir}${base_name}"
    local sym_link_path="${pyosphere_dir}.${base_name}.alias"
    [[ ! -f "${hard_link_path}" ]] && ln "${path}" "${hard_link_path}"
    [[ ! -L "${sym_link_path}" ]] && ln -s "${path}" "${sym_link_path}"
  done < <(eval ${find_command})
  [[ $is_python_project == false ]] && rm -r "${pyosphere_dir}" && echo "Build failed. Not a python project." && exit > "${output}" || echo "Build generated." > "${output}"
}

# Clean project
clean() {
  if [[ -d "${pyosphere_dir}" ]]
  then
    echo "${bold}Cleaning...${normal}" > "${output}"
    rm -r "${pyosphere_dir}"
    echo "Clean successful." > "${output}"
  else
    echo "Nothing to clean." > "${output}"
  fi
}

# Reset project
reset() {
  echo "${bold}Resetting...${normal}" > "${output}"
  clean
  [[ -f "${pyosphere_config}" ]] && rm "${pyosphere_config}"
  echo "Reset complete." > "${output}"
}

# ----- PYOSPHERE CONTROL FLOW

# Start pyosphere with environment set
begin_execution() {
  parse_pyosphere_config
  pyosphere_dir="${given_project_path}${pyosphere_dir}"
  mkdir -p "${pyosphere_dir}"
  generate_build
  [[ $always_prune_pref == true ]] && prune_build
  execute
}

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
    generate_pyosphere_config
    ;;
    -ie=*|--init-exec=*)
    local execution_file="${@#*=}"
    [[ -z "${execution_file}" ]] && echo "No run source provided." && return
    given_run_source="${execution_file}"
    generate_pyosphere_config
    ;;
    -r|--reset)
    reset
    ;;
    -p|--prune)
    prune_build
    ;;
    -s|--silent)
    output="/dev/null"
    begin_execution
    ;;
    -cf=*|--config-file=*)
    local config_file="${@#*=}"
    [[ -z "${config_file}" ]] && echo "No configuration file provided." && return
    pyosphere_config="${config_file}"
    begin_execution
    ;;
    "")
    begin_execution
    ;;
    *)
    echo "Invalid argument. Run with ${underline}-h${normal} for help."
    ;;
  esac
}

parse_args "${@}"
