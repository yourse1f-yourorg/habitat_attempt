#!/bin/sh
#
SERVICE=nginx;
UNIT_FILE=${SERVICE}.service;
RUNNER=run_${SERVICE}.sh;
REMOTE_HAB_USER=hab;

echo "--> Make an installer directory for '${SERVICE}' for user '${REMOTE_HAB_USER}' on host : '${REMOTE_HOST}' . . .";
# echo "ssh -t ${REMOTE_HAB_USER}@${REMOTE_HOST} mkdir -p ${SERVICE};";
ssh -qt ${REMOTE_HAB_USER}@${REMOTE_HOST} mkdir -p ${SERVICE};

echo "--> Send the 'systemd' unit file for '${SERVICE}', to host '${REMOTE_HOST}' . . . ";
# echo "scp ${SERVICE}/unit_file  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${UNIT_FILE};";
scp ${SERVICE}/unit_file  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${UNIT_FILE} > /dev/null;

echo "--> Send the 'runner' script, for '${SERVICE}', to host '${REMOTE_HOST}' . . . ";
# echo "scp ${SERVICE}/runner.sh  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${RUNNER} > /dev/null;";
scp ${SERVICE}/runner.sh  ${REMOTE_HAB_USER}@${REMOTE_HOST}:/home/${REMOTE_HAB_USER}/${SERVICE}/${RUNNER} > /dev/null;

echo "--> Run the '${SERVICE}' runner as user: '${REMOTE_HAB_USER}' . . .";
# echo "ssh -t ${REMOTE_HAB_USER}@${REMOTE_HOST} ./${SERVICE}/${RUNNER};";
ssh -qt ${REMOTE_HAB_USER}@${REMOTE_HOST} ./${SERVICE}/${RUNNER};

