#!/bin/bash -e
sudo -u ${FIRST_USER_NAME} NVM_DIR=${NVM_DIR} -i bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash'
sudo -u ${FIRST_USER_NAME} NVM_DIR=${NVM_DIR} NODE_VERSION=${NODE_VERSION} -i bash -c '\. $NVM_DIR/nvm.sh && nvm install $NODE_VERSION'
