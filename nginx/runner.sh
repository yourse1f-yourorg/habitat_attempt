#!/bin/sh
#
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

SERVICE=nginx;
UNIT_FILE=${SERVICE}.service;
BASE_DIR=/hab/svc/${SERVICE};

PRETTY="\n  ==> On target server :";

echo "${PRETTY} Copy service to 'systemd' directory";
sudo cp ${SCRIPTPATH}/${UNIT_FILE} /etc/systemd/system > /dev/null;

echo "${PRETTY} Enable the '${SERVICE}' systemd service . . .";
sudo systemctl enable ${UNIT_FILE};

echo "${PRETTY} Make sure there is a directory available for '${SERVICE}' logs";
sudo mkdir -p ${BASE_DIR}/var/logs; # > /dev/null;
sudo mkdir -p ${BASE_DIR}/data; # > /dev/null;
sudo touch ${BASE_DIR}/data/index.html;
sudo find ${BASE_DIR} -type d -print0 | sudo xargs -0 chmod 770; # > /dev/null;
sudo find ${BASE_DIR} -type f -print0 | sudo xargs -0 chmod 660; # > /dev/null;
whoami;
sudo chown -R hab:hab ${BASE_DIR};
sudo ls -l ${BASE_DIR};
sudo ls -l ${BASE_DIR}/data;
sudo ls -l ${BASE_DIR}/data/index.html;
sudo echo "nginx is ready" >> ${BASE_DIR}/data/index.html;

echo "${PRETTY} Start up the '${SERVICE}' systemd service . . .";
sudo systemctl start ${SERVICE};


sudo ls -l ${BASE_DIR}/var/logs;
sudo ls -l ${BASE_DIR}/data/index.html;

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

exit 0;

sudo rm -f  /etc/systemd/system/nginx.service;
sudo rm -f  /etc/systemd/system/multi-user.target.wants/nginx.service;
sudo rm -f  /hab/cache/artifacts/core-nginx-1.10.1-20160902203245-x86_64-linux.hart;
sudo rm -fr /hab/pkgs/core/nginx;
sudo rm -fr /hab/svc/nginx;
sudo rm -fr /home/hab/nginx;

sudo updatedb && locate nginx;
