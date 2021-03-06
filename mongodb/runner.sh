#!/bin/sh
#
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

SERVICE=mongodb;
UNIT_FILE=${SERVICE}.service;

PRETTY="\n  ==> On target server :";

echo "${PRETTY} Copy service to 'systemd' directory";
sudo cp ${SCRIPTPATH}/${UNIT_FILE} /etc/systemd/system > /dev/null;

echo "${PRETTY} Enable the '${SERVICE}' systemd service . . .";
sudo systemctl enable ${UNIT_FILE};

echo "${PRETTY} Start up the '${SERVICE}' systemd service . . .";
sudo systemctl start ${SERVICE};

echo "";
echo "";
echo "  * * *  Some commands you might find you need  * * *  ";
echo "         .  .  .  .  .  .  .  .  .  .  .  .  .  ";
echo "";
echo "  Status of services :      systemctl list-unit-files --type=service |  grep ${SERVICE}  ";
echo "          Enable  it : sudo systemctl  enable ${SERVICE}.service  ";
echo "          Disable it : sudo systemctl disable ${SERVICE}.service  ";
echo "";
echo "  #  Controlling it  ";
echo "  systemctl status ${SERVICE}  ";
echo "  sudo systemctl stop ${SERVICE}  ";
echo "  sudo systemctl start ${SERVICE}  ";
echo "  sudo systemctl restart ${SERVICE}  ";
echo "";
