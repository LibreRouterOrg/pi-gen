#!/bin/bash -e
NODE_VERSION=12.13.1
sudo -i -u ${FIRST_USER_NAME} bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash'
sudo NODE_VERSION=${NODE_VERSION} -i -u ${FIRST_USER_NAME} bash -c '[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh && nvm install $NODE_VERSION'
sudo -i -u ${FIRST_USER_NAME} bash -c 'cd $HOME && git clone https://github.com/LibreRouterOrg/soporteremoto-dashboard.git'
sudo -i -u ${FIRST_USER_NAME} bash -c '[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh && cd $HOME/soporteremoto-dashboard/federated-server && npm install'
# Create a systemd service
cat << EOF
[Unit]
Description="SoporteRemoto Federated Server"
Wants=network-online.target
After=network.target network-online.target

[Service]
Environment=NODE_VERSION=${NODE_VERSION}
ExecStart=/home/${FIRST_USER_NAME}/.nvm/nvm-exec npm start run.js
ExecStop=/home/${FIRST_USER_NAME}/.nvm/nvm-exec npm stop federated-server
WorkingDirectory=/home/${FIRST_USER_NAME}/soporteremoto-dashboard/federated-server
User=${FIRST_USER_NAME}

[Install]
WantedBy=multi-user.target
EOF

systemctl enable sr-server.service
