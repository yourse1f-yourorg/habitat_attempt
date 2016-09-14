# MetHabi

A deployment process for Meteor applications, built from Chef Habitat

Specific Task.  Standard Tools.

## Overview

MetHabi works in several phases :

1. Initial hook up to your target server
2. First time deployment
3. Subsequent deployments

### Initial Hook Up

MetHabi needs to create a user account `hab` on your target server.  This account will have passwordless `sudo` privileges for running [Chef Habitat](https://www.habitat.sh/).  It also needs to install the Habitat executable also called `hab`.

The script `CommissionHabitatHost.sh` attempts to connect to the target server and upload a remotely callable shell script `PrepareChefHabitat.sh`.

`PrepareChefHabitat.sh` creates a user called `hab` and then obtains `hab` and prepares it for use.


### First Deployment

MetHabi

### Steps

1. Install Meteor -- ```curl https://install.meteor.com/ | sh```
1. Install nvm -- ```curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash```
1. Ensure we have g++ -- ```sudo apt install -y g++```
1. Install NodeJS 4.4.7 -- ```nvm install v4.4.7```
1. Clone our simple-todos -- ```git clone https://github.com/yourse1f-yourorg/simple-todos```
1. Prepare it -- ```cd simple-todos  &&  npm install```
1. Check it -- ```meteor```
1. Find the MongoDB, NodeJS and NginX packages on https://app.habitat.sh
  1. [billmeyer/mongodb](https://app.habitat.sh/#/pkgs/billmeyer/mongodb/3.2.6/20160824195527)
  2. [looprock/node](https://app.habitat.sh/#/pkgs/looprock/node/4.4.7/20160710215340)
  3. [core/nginx](https://app.habitat.sh/#/pkgs/core/nginx/1.10.1/20160818203156)
1.
1.
1.
1.
1.
1.
1.

