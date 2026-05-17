# Location of this script
scriptDir="$(dirname "$(readlink -f "${BASH_SOURCE[0]:-${(%):-%x}}")")"

# QUESTA_HOME should point to Questa installation directory
# handled by questa initialization on SoC-Courses-VM
if [ -z ${QUESTA_HOME+x} ]; then
  echo "QUESTA_HOME unset"
  echo "Remember to source the course environment script"
fi

# linux-desktop
#export QUESTA_HOME=/opt/lintula/modelsim/10.7d/modeltech

export UVM_REGISTER=$scriptDir/uvm_register-2.0
