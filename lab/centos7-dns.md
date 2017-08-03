# Centos 7 - DNS server
##### pre-requisites - cento 7 minimal
1 network interface set to network 192.168.111.0/24 e.g. 192.168.111.1
internet connection or centos iso image mounted and configured as yum repository
to enable installation of the reuired packages.

##### steps to be performed as user _root_:
```
yum install bind -y
```
after successful installation of the above:
```
cat > /etc/dhcp/dhcpd.conf << "EOF"
EOF
systemctl enable later
systemctl start later
```
