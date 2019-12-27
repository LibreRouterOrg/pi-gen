#! /bin/bash

# Setup a random tinc hostname of 12 characters.
TINC_HOSTNAME="sr_$(tr -dc 'A-Z0-9' < /dev/urandom | head -c12)"
IPV6_PREFIX="2a00:1508:1:f003"

get_ipv6(){
	# Copyright Vladislav V. Prodan universite@ukr.net 2011
	array=( 1 2 3 4 5 6 7 8 9 0 a b c d e f )
	a=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
	b=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
	c=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
	d=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
	echo $IPV6_PREFIX:$a:$b:$c:$d
}

add_name_to_tinc(){
	echo "Name = $TINC_HOSTNAME" >> /etc/tinc/librenet6/tinc.conf
}

setup_credentials(){
	tincd -n librenet6 -K </dev/null
	# Give everyone access to read the RSA Public key 
	chmod a+r /etc/tinc/librenet6/hosts/$TINC_HOSTNAME
}

add_ip_to_interface(){
	IPV6=$(get_ipv6)
	echo "ip -6 address add $IPV6/64 dev \$INTERFACE" >> /etc/tinc/librenet6/tinc-up
}


if [ ! -e /etc/tinc/librenet6/is_configured ] then
	add_name_to_tinc()
	setup_credentials()
	add_ip_to_interface()
	touch /etc/tinc/librenet6/is_configured
else
	echo "Librenet6 is already setup"
fi
