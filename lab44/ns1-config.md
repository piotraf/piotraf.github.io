# Post install setup of linux Centos 7 router for LAB44
* assumption - the system was created with ns1.ks and the network interfaces names are:
   * connection to the internet dynamic IP - interface after innstalation is named "System enp0s3"
   * connection to the intranet (LAB44) static IP 192.168.44.254 - interface after innstalation is named "System enp0s8"
    
## create Name Server 
```
yum install unbound -y
```

```cp /etc/unbound/unbound.conf{,.orig}```

```
sed -i 's/# interface: 0.0.0.0$\/interface: 0.0.0.0/g' \
/etc/unbound/unbound.conf
```

```
sed -i 's/\# access-control: 127.0.0.0\/8 allow/access-control: \
192.168.0.0\/16 allow/g' /etc/unbound/unbound.conf
```

```mv /etc/unbound/conf.d/example.com.conf{,.stub-zone}```

```
cat >> /etc/unbound/conf.d/example.com.conf << "EOF"
server:
local-zone: "example.com." static
local-data: "ns1.example.com.  IN A 192.168.44.254"
local-data-ptr: "192.168.44.254  ns1.example.com"
local-data-ptr: "192.168.44.1  vbox.example.com"
local-data: "vbox.example.com.  IN A 192.168.44.1"
EOF
```

```
cat >> /etc/unbound/conf.d/forward-zone.conf << "EOF"
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
EOF
```

```systemctl enable --now unbound```

```firewall-cmd --zone=internal --add-service=dns --permanent```

```firewall-cmd --reload```

```nmcli c m 'System enp0s3' ipv4.dns '192.168.44.254'  +ipv4.ignore-auto-dns 'yes'```

```nmcli c m 'System enp0s8'  ipv4.dns '' +ipv4.ignore-auto-dns 'yes'```

```nmcli c up 'System enp0s8'```

## create DHCP server for the LAB44
```yum install dhcp -y```

```
cat > /etc/dhcp/dhcpd.conf << "EOF"
# dhcpd.conf
# see more at /usr/share/doc/dhcp*/dhcpd.conf.example
# option definitions common to all supported networks...
option domain-name "example.com";
option domain-name-servers ns1.example.com, ns2.example.com;
default-lease-time 600;
max-lease-time 7200;
# Use this to enble / disable dynamic dns updates globally.
ddns-updates           on;
ddns-update-style      interim;
ignore                 client-updates;
update-static-leases   on;
# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;
# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;
subnet 192.168.44.0 netmask 255.255.255.0 {
        option routers                  192.168.44.254;
        option subnet-mask              255.255.255.0;
        option domain-name-servers       192.168.44.254;
range 192.168.44.240 192.168.44.249;
#host workstation {
#     hardware ethernet 08:00:27:b0:d0:1a;
#     fixed-address 192.168.44.2;
#	}
}
EOF
```

```systemctl enable --now dhcpd```
