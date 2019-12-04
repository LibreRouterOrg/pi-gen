#!/bin/bash -e
sudo -u ${FIRST_USER_NAME} -i bash -c 'cd ${HOME} && git clone https://github.com/LibreRouterOrg/soporteremoto-dashboard.git'
sudo -u ${FIRST_USER_NAME} NVM_DIR=${NVM_DIR} -i bash -c '\. $NVM_DIR/nvm.sh && cd ${HOME}/soporteremoto-dashboard/federated-server && npm install'
# Create a systemd service
cat > /etc/systemd/system/sr-server.service << EOF
[Unit]
Description="SoporteRemoto Federated Server"
Wants=network-online.target
After=network.target network-online.target

[Service]
Environment=NODE_VERSION=${NODE_VERSION}
ExecStart=${NVM_DIR}/nvm-exec npm start run.js
ExecStop=${NVM_DIR}/nvm-exec npm stop federated-server
WorkingDirectory=/home/${FIRST_USER_NAME}/soporteremoto-dashboard/federated-server
User=${FIRST_USER_NAME}

[Install]
WantedBy=multi-user.target
EOF
systemctl enable sr-server.service
