#!/bin/sh

HAB_USER=${1};
HAB_PASSWD=${2};
PRETTY="\n  ==> On target server :";

HAB_DIR=/home/${HAB_USER};
HAB_SSH_DIR=${HAB_DIR}/.ssh;
HAB_SSH_AXS=${HAB_SSH_DIR}/authorized_keys;

downloadHabToPathDir() {

  INST_HOST="https://api.bintray.com";
  INST_STABLE="content/habitat/stable";
  INST_PATH="${INST_HOST}/${INST_STABLE}";

  INST_MAC="darwin";
  INST_LNX="linux";

  INST_SFX_MAC="zip";
  INST_SFX_LNX="tar.gz";
  INST_SFX="${INST_SFX_LNX}";

  INST_FILE="hab-%24latest";

  INST_PARM="bt_package";

  ARCH="x86_64";

  OS="darwin";
  OS="linux";
  OS="${1:-linux}";

  DEST_DIR="${2:-/usr/local/bin}";

  if [ "${OS}" = "${INST_MAC}" ]; then
    INST_SFX="${INST_SFX_MAC}";
    # echo "APPLE https://api.bintray.com/content/habitat/stable/darwin/x86_64/hab-%24latest-x86_64-darwin.zip   ?bt_package=hab-x86_64-darwin";
  else
    INST_SFX="${INST_SFX_LNX}";
    # echo "LINUX https://api.bintray.com/content/habitat/stable/linux/x86_64/hab-%24latest-x86_64-linux.tar.gz?bt_package=hab-x86_64-linux";
  fi;

  INST_BUNDLE="${INST_FILE}-${ARCH}-${OS}.${INST_SFX}";
  INST_TRGT="hab-${ARCH}-${OS}.${INST_SFX}";
  INST_URL="${INST_PATH}/${OS}/${ARCH}/${INST_BUNDLE}?${INST_PARM}=hab-${ARCH}-${OS}";

  PATTERN="hab-*-${ARCH}-${OS}";

  # echo "DWNLD ${INST_URL}";
  wget --quiet --no-clobber -O ${INST_TRGT} ${INST_URL} > /dev/null;
  rm -fr ${PATTERN};
  tar zxf ${INST_TRGT};

  INST_DIR=$( ls -d ${PATTERN} );
  # echo "Install from ${INST_DIR}/hab to ${DEST_DIR}";

  sudo mv ${INST_DIR}/hab ${DEST_DIR};
  DEST_FILE=${DEST_DIR}/hab;
  sudo chmod 755 ${DEST_FILE};
  sudo chown root:root ${DEST_FILE};

  rm -fr ${PATTERN};

}

if echo "${HAB_PASSWD}" | grep -E "^.{8,}$" > /dev/null 2>&1 ; then

  echo "${PRETTY} purging any existing user '${HAB_USER}' . . .  ";
  sudo deluser --quiet --remove-home ${HAB_USER}  > /dev/null 2>&1;
  sudo rm -fr "/etc/sudoers.d/${HAB_USER}";

  echo "${PRETTY} creating user '${HAB_USER}' . . .  ";
  sudo adduser --disabled-password --gecos "" ${HAB_USER};

  echo "${PRETTY} ensuring command 'mkpassword' exists . . .  ";
  sudo apt-get install -y whois > /dev/null;

  echo "${PRETTY} setting password for user '${HAB_USER}' . . .  ";
  sudo usermod --password $( mkpasswd ${HAB_PASSWD} ) ${HAB_USER};

  echo "${PRETTY} adding user '${HAB_USER}' to sudoers . . .  ";
  sudo usermod -aG sudo ${HAB_USER};

  echo "${PRETTY} let '${HAB_USER}' account use sudo without password . . .  ";
  echo "${HAB_USER} ALL=(ALL) NOPASSWD:ALL" | (sudo su -c "EDITOR='tee' visudo -f /etc/sudoers.d/${HAB_USER}") > /dev/null;

  echo "${PRETTY} adding caller's credentials to authorized SSH keys of '${HAB_USER}' . . .  ";
  sudo mkdir -p ${HAB_SSH_DIR};
  sudo mv id_rsa.pub ${HAB_SSH_AXS};
  sudo chown -R ${HAB_USER}:${HAB_USER} ${HAB_SSH_DIR};

  echo "${PRETTY} obtaining 'hab'.";

  DEST_DIR="/usr/local/bin";
  downloadHabToPathDir linux ${DEST_DIR};
  echo "${PRETTY} installed 'hab' to '${DEST_DIR}'.\n\n";



else
    echo "Error : ${HAB_PASSWD}.  Password must be 8 chars minimum.";
fi

