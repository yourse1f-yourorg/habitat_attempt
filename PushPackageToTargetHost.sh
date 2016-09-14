#!/bin/sh
#
SCRIPT=$(readlink -f "$0");
SCRIPTPATH=$(dirname "$SCRIPT");
# echo "Absolute path of this script is ${SCRIPTPATH}.";

# Get shell constants
. ${SCRIPTPATH}/constants.sh;

pushToHost() {

  echo "Installing service : '$1'.";

  SERVICE=$1;
  UNIT_FILE=${SERVICE}.service;
  RUNNER=run_${SERVICE}.sh;

  echo "--> Make an installer directory for '${SERVICE}' for user '${REMOTE_HAB_USER}' on host : '${REMOTE_HOST}' . . .";
  echo "ssh -t ${REMOTE_HAB_USER}@${REMOTE_HOST} mkdir -p ${SERVICE};";
  ssh -qt ${REMOTE_HAB_USER}@${REMOTE_HOST} mkdir -p ${SERVICE};

  echo "--> Send the 'systemd' unit file for '${SERVICE}', to host '${REMOTE_HOST}' . . . ";
  echo "scp ${SCRIPTPATH}/${SERVICE}/unit_file  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${UNIT_FILE};";
  scp ${SCRIPTPATH}/${SERVICE}/unit_file  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${UNIT_FILE} > /dev/null;

  echo "--> Send the 'runner' script, for '${SERVICE}', to host '${REMOTE_HOST}' . . . ";
  echo "scp ${SCRIPTPATH}/${SERVICE}/runner.sh  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${RUNNER} > /dev/null;";
  scp ${SCRIPTPATH}/${SERVICE}/runner.sh  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${RUNNER} > /dev/null;

  echo "--> Run the '${SERVICE}' runner as user: '${REMOTE_HAB_USER}' . . .";
  echo "ssh -t ${REMOTE_HAB_USER}@${REMOTE_HOST} ./${SERVICE}/${RUNNER};";
  ssh -qt ${REMOTE_HAB_USER}@${REMOTE_HOST} ./${SERVICE}/${RUNNER};

};

# echo "--> Send the 'runner' script, for '${SERVICE}', to host '${REMOTE_HOST}' . . . ";
# echo "scp ${SERVICE}/runner.sh  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${RUNNER} > /dev/null;";
# scp ${SERVICE}/runner.sh  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${RUNNER} > /dev/null;

# echo "--> Run the '${SERVICE}' runner as user: '${REMOTE_HAB_USER}' . . .";
# echo "ssh -t ${REMOTE_HAB_USER}@${REMOTE_HOST} ./${SERVICE}/${RUNNER};";
# ssh -qt ${REMOTE_HAB_USER}@${REMOTE_HOST} ./${SERVICE}/${RUNNER};
