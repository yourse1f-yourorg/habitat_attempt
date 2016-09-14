#!/bin/sh
#

PREP_SCRIPT=PrepareChefHabitat.sh;
SANE="true";

PUBKEY=${HOME}/.ssh/id_rsa.pub;
if [ ! -f ${PUBKEY} ]; then
    echo "
    Error : You will need a secure shell public key '${PUBKEY}'.";
    SANE="false";
fi

if ! echo "${REMOTE_HOST}" | grep -E "^.{2,}$" > /dev/null 2>&1 ; then
    echo "
    Error : Environment variable REMOTE_HOST '${REMOTE_HOST}' seems too short.";
    echo "
        REMOTE_HOST should be the domain name or IP addr of the host where Habitat will be installed.";
    SANE="false";
fi

if ! echo "${REMOTE_HOST_USER}" | grep -E "^.{2,}$" > /dev/null 2>&1 ; then
    echo "
    Error : Environment variable REMOTE_HOST_USER '${REMOTE_HOST_USER}' seems too short.";
    SANE="false";
fi

if ! echo "${REMOTE_HABITAT_PASSWD}" | grep -E "^.{8,}$" > /dev/null 2>&1 ; then
    echo "
    Error : Environment variable REMOTE_HABITAT_PASSWD must be 8 chars minimum.";
    SANE="false";
fi

REMOTE_HAB_USER=habuser;
if ${SANE} = "true"; then

    echo "--> Send public key that represents '${USER}' to host '${REMOTE_HOST}'. . . ";
    scp ${HOME}/.ssh/id_rsa.pub ${REMOTE_HOST}:/home/${REMOTE_HOST_USER}/ > /dev/null;

    echo "--> Send script, that preps host for Habitat, to host '${REMOTE_HOST}' . . . ";
    scp ${PREP_SCRIPT} ${REMOTE_HOST}:/home/${REMOTE_HOST_USER}/;

    echo "--> Prepare Habitat user and executable : '${REMOTE_HAB_USER}' . . .";
    ssh -t ${REMOTE_HOST} ./${PREP_SCRIPT} ${REMOTE_HAB_USER} ${REMOTE_HABITAT_PASSWD};

    echo "--> Back from remote procedure to prepare Habitat on '${REMOTE_HOST}'.";

else

  echo "\n  *** Typical execution looks like this : ";
  echo "export REMOTE_HOST_USER='you'; # a user on the machine where Habitat is to run";
  echo "export REMOTE_HOST='192.168.122.123'; # IP addr or domain name of the remote machine";
  echo "export REMOTE_HABITAT_PASSWD='ʇǝɹɔǝs' # the password of the new Habitat user on the remote machine";
  echo "#./CommissionHabitatHost.sh";

fi
