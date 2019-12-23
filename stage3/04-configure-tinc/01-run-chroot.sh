mkdir -p /etc/tinc/librenet6/hosts
echo librenet6 >> /etc/tinc/nets.boot
cat << EOF > /etc/tinc/librenet6/tinc.conf
Name = host_$(hostname)
Mode = switch
EOF

### Systemd startup script for generating tinc public key for this client node
install -v -m 744 files/generate_tinc_keys.sh /opt/generate_tinc_keys.sh

cat > /etc/systemd/system/tinc-credentials.service << EOF
[Unit]
Description=Setup tinc credentials for librenet6

[Service]
Type=oneshot
ExecStart=/opt/generate_tinc_keys.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
systemctl enable tinc-credentials.service

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

systemctl enable tinc.service
