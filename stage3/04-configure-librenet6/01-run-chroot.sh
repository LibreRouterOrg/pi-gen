## Static configuration for librenet6. This configuration is the same for all devices.
mkdir -p /etc/tinc/librenet6/hosts
echo librenet6 >> /etc/tinc/nets.boot

# Setup tinc.conf
cat << EOF > /etc/tinc/librenet6/tinc.conf
Mode = switch
ConnectTo = topu
EOF

# Setup tinc-up
cat << EOF >/etc/tinc/librenet6/tinc-up
#!/bin/sh
ip -6 link set \$INTERFACE up txqueuelen 1000
echo 2 > /proc/sys/net/ipv6/conf/\$INTERFACE/accept_ra
babeld -D \$INTERFACE
EOF
chmod +x /etc/tinc/librenet6/tinc-up

# Setup topu host
cat << EOF > /etc/tinc/librenet6/hosts/topu
Address = chato.altermundi.net

-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEA47/rwyb5UBe28/Hrtga8vDh9kFTew2x5Qz/WXrVNy7WWoEzsPhjw
UaHNhREuy1gqLcjyzo4QfzZFgEMimmyMYsEqf3B9gKNJJBDGNTRSI8qJOq5WxeyE
5VsEtdgplHC529C1k4sDx5dqv8h0ynsSOKjgBBnxTXTW3qqaDXKoZ5ZtqrzVNeuh
xGHLUP8x4w4CBJ68/+hbqjz91WdE2gzi63f0Dw50uOuur7matrrImFDJRtZuun8I
RuHe74qk7JFD46JojgWjgRlqKUPQN0EuZfXOzMUFUswhGBIHDK9Qw7dGG4mDxzTM
0j9aoBqYUmHCxia93jp42ENfAIgqezznXQIDAQAB
-----END RSA PUBLIC KEY-----
EOF

# Setup tinc-down
cat <<EOF >/etc/tinc/librenet6/tinc-down
#!/bin/sh
killall babeld
EOF
chmod +x /etc/tinc/librenet6/tinc-down

# Enable tinc service
systemctl enable tinc@librenet6

## Device specific configuration for librenet6 handled by systemd startup script.
cat > /etc/systemd/system/librenet6-configure.service << EOF
[Unit]
Description=Setup the device to join librenet6
Before=tinc.service

[Service]
Type=oneshot
ExecStart=/opt/configure_librenet6.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
systemctl enable librenet6-configure.service

