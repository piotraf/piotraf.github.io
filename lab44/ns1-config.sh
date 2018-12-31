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
# renaming the network interfaces to get rid of the "System" and "enp0sX" naming
nmcli connection modify "System enp0s3" connection.interface-name "external"
nmcli connection modify "System enp0s8" connection.interface-name "internal"
## create DHCP server for the LAB44


