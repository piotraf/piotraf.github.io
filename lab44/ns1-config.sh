#!/bin/bash
#
# LICENSE UPL 1.0
#
# Copyright (c) 2019 Piotr Fratczak and/or its affiliates. All rights reserved.
# 
# Since: January, 2019
# Author: Piotr Fratczak piotr4f (at) gmail.com
# Description: Post install setup of linux Centos 7 router for LAB44
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# assumption - the system was created with ns1.ks and the network interfaces names are:
# connection to the internet dynamic IP - interface after innstalation is named "System enp0s3"
# connection to the intranet (LAB44) static IP 192.168.44.254 - interface after innstalation is named "System enp0s8"
# create Name Server 
yum install unbound -y 
cp /etc/unbound/unbound.conf{,.orig}
sed -i 's/# interface: 0.0.0.0$/interface: 0.0.0.0/g' /etc/unbound/unbound.conf
sed -i 's/\# access-control: 127.0.0.0\/8 allow/access-control: 192.168.0.0\/16 allow/g' /etc/unbound/unbound.conf
mv /etc/unbound/conf.d/example.com.conf{,.stub-zone}
cat >> /etc/unbound/conf.d/example.com.conf << "EOF"
server:
local-zone: "example.com." static
local-data: "ns1.example.com.  IN A 192.168.44.254"
local-data-ptr: "192.168.44.254  ns1.example.com"
local-data-ptr: "192.168.44.1  vbox.example.com"
local-data: "vbox.example.com.  IN A 192.168.44.1"
###############
EOF
cat >> /etc/unbound/conf.d/forward-zone.conf << "EOF"
##########
forward-zone:
      name: "."
      forward-addr: 8.8.4.4        # Google
      forward-addr: 8.8.8.8        # Google
      forward-addr: 37.235.1.174   # FreeDNS
      forward-addr: 37.235.1.177   # FreeDNS
      forward-addr: 50.116.23.211  # OpenNIC
      forward-addr: 64.6.64.6      # Verisign
      forward-addr: 64.6.65.6      # Verisign
      forward-addr: 74.82.42.42    # Hurricane Electric
      forward-addr: 84.200.69.80   # DNS Watch
      forward-addr: 84.200.70.40   # DNS Watch
      forward-addr: 91.239.100.100 # censurfridns.dk
      forward-addr: 109.69.8.51    # puntCAT
      forward-addr: 208.67.222.220 # OpenDNS
      forward-addr: 208.67.222.222 # OpenDNS
      forward-addr: 216.146.35.35  # Dyn Public
      forward-addr: 216.146.36.36  # Dyn Public
############
EOF
systemctl enable --now unbound
firewall-cmd --zone=internal --add-service=dns --permanent
firewall-cmd --reload
## create DHCP server for the LAB44


