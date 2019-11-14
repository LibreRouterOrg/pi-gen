#!/bin/bash -e
# fetch and install nvm
cd $HOME
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
# load nvm into path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# install lts version. Automatically resolves architecture (armv7)
nvm install --lts
# Get soporteremoto code
git clone https://github.com/LibreRouterOrg/soporteremoto-dashboard.git
# Install forever to run server in a daemon process.
npm install -g forever
cd soporteremoto-dashboard/federated-server
# Install dependencies
npm install
# Run
forever start run.js
