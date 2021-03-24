
# This functions:
#   - changes the current working directory to the folder containing Ansible scripts
#   - sets ${mvn_project_basedir} variable, to refer to the actual location of the application.
#
# The function accepts an optional parameter - application folder name.
#   Mostly this name equals to ${artifact_id} Ansible variable.
#   If you omit the input parameter, the current folder is used by default
function changePwd2AnsibleScriptsFolder() {

  local pwd_path=$(pwd)
  echo "The present working directory is '${pwd_path}'"

  # set the application basedir
  local app_folder_name=$1
  # do net mark variable as 'local', it is a return value for this function!
  app_basedir=$( [ -z "${app_folder_name}" ] && echo "${pwd_path}" || echo "${pwd_path}/${app_folder_name}")
  echo "The application basedir '${app_basedir}'"

  local ansible_scripts_location=`dirname "$0"`
  echo "The script you are running located in '${ansible_scripts_location}'"

  echo "Switching to the parent of '${ansible_scripts_location}' folder"
  cd ${ansible_scripts_location}
  cd ..
  echo "The present working directory for running Ansible playbook has been switched to `pwd`"
}