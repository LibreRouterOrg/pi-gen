#! /bin/bash
if [ ! -s /etc/tinc/librenet6/hosts/host_$(hostname) ] && \
   [ ! -s /etc/tinc/librenet6/rsa_key.priv ]; then
   tincd -n librenet6 -K </dev/null
   # Give everyone access to read the RSA Public key 
   chmod a+r /etc/tinc/librenet6/hosts/host_$(hostname)
else
    echo "Tinc credentials are already setup"
fi
