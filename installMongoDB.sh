#!/bin/sh
#

echo "--> Send the systemd unit file for mongodb, to host '${REMOTE_HOST}' . . . ";
scp mongodb.service ${REMOTE_HOST}:/home/${REMOTE_HOST_USER}/;



