## Setup unique device hostname with a systemd startup script.
cat > /etc/systemd/system/configure-hostname.service << EOF
[Unit]
Description=Setup the device hostname to be a unique name

[Service]
Type=oneshot
ExecStart=/opt/configure-hostname.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
systemctl enable configure-hostname.service
