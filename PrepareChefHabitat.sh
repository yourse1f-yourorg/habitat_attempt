#!/bin/sh
  
HAB_USER=${1};
HAB_PASSWD=${2};
PRETTY="\n  ==> On target server :";

HAB_DIR=/home/${HAB_USER};
HAB_SSH_DIR=${HAB_DIR}/.ssh;
HAB_SSH_AXS=${HAB_SSH_DIR}/authorized_keys;

if echo "${HAB_PASSWD}" | grep -E "^.{8,}$" > /dev/null 2>&1 ; then

  echo "${PRETTY} removing any existing user '${HAB_USER}' . . .  ";
  sudo deluser --quiet --remove-home ${HAB_USER}  > /dev/null 2>&1

  echo "${PRETTY} creating user '${HAB_USER}' . . .  ";
  sudo adduser --disabled-password --gecos "" ${HAB_USER}

  echo "${PRETTY} ensuring command 'mkpassword' exists . . .  ";
  sudo apt-get install -y whois > /dev/null;

  echo "${PRETTY} setting password for user '${HAB_USER}' . . .  ";
  sudo usermod --password $( mkpasswd ${HAB_PASSWD} ) ${HAB_USER};

  echo "${PRETTY} adding user '${HAB_USER}' to sudoers . . .  ";
  sudo usermod -aG sudo ${HAB_USER};

  echo "${PRETTY} adding caller's credentials to authorized SSH keys of '${HAB_USER}' . . .  ";
  
  sudo mkdir -p ${HAB_SSH_DIR};
  sudo mv id_rsa.pub ${HAB_SSH_AXS};
  sudo chown -R ${HAB_USER}:${HAB_USER} ${HAB_SSH_DIR};
  
  sudo mv ${HOME}/hab /usr/bin;
  sudo chmod 755 /usr/bin/hab;
  sudo chown root:root /usr/bin/hab;
  
  echo "${PRETTY} Finished creating user '${HAB_USER}'.\n\n";

else
    echo "Error : ${HAB_PASSWD}.  Password must be 8 chars minimum.";
fi

