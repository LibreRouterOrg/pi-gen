#! /bin/bash
if [ ! -e /etc/hostname_is_configured ] then
    # Setup a random tinc hostname of 12 characters.
    OLD_HOSTNAME=$(hostname)
    NEW_HOSTNAME="$(tr -dc 'A-Z0-9' < /dev/urandom | head -c12)"
    echo $NEW_HOSTNAME > /etc/hostname
    sed -i 's/$OLD_HOSTAME/$NEW_HOSTANME/g' /etc/hosts
    touch /etc/hostname_is_configured
    hostname -F /etc/hostname
else
    echo "Hostname is already configured"
fi
