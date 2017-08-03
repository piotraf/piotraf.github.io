# Centos 7 - DHCP server
##### pre-requisites - cento 7 minimal
1 network interface set to network 192.168.111.0/24 e.g. 192.168.111.1
internet connection or centos iso image mounted and configured as yum repository
to enable installation of the reuired packages.

##### steps to be performed as user _root_:
```
yum install dhcp -y
```
after successful installation of the above:
```
cat > /etc/dhcp/dhcpd.conf << "EOF"
ddns-update-style ad-hoc;
ddns-update-style interim;
subnet 192.168.111.0 netmask 255.255.255.0 {
        option routers                  192.168.111.1;
        option subnet-mask              255.255.255.0;
        option domain-name              "example.com";
        option domain-name-servers       8.8.8.8;
	range 192.168.111.10 192.168.111.100;
}
EOF
systemctl enable dhcpd
systemctl start dhcpd
```
