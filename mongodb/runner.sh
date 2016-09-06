#!/bin/sh
#
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

SERVICE=mongodb;
UNIT_FILE=${SERVICE}.service;

PRETTY="\n  ==> On target server :";

echo "${PRETTY} Let's roll";
echo "${PRETTY} Copy service to 'systemd' directory";
ls -l ${SCRIPTPATH}/${UNIT_FILE};
sudo cp ${SCRIPTPATH}/${UNIT_FILE} /etc/systemd/system > /dev/null;

echo "${PRETTY} Enable the '${SERVICE}' systemd service . . .";
sudo systemctl enable ${UNIT_FILE};
sudo systemctl start ${SERVICE};
