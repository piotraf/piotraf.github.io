##############################################################
#                      ns1.ks template                       #
# append to the boot kernel line (use TAB):                  #
# inst.ks=http://piotraf.github.io/lab56/ns1.ks              #
##############################################################
install
text
cdrom
lang pl_PL.UTF-8
keyboard pl2
timezone --utc Europe/Warsaw --ntpservers=0.pl.pool.ntp.org,1.pl.pool.ntp.org,2.pl.pool.ntp.org,3.pl.pool.ntp.org
network --onboot=yes --bootproto=dhcp --device=enp0s3 --nameserver=192.168.4.254 --ipv6=auto --activate
network --onboot=yes --bootproto=static --device=enp0s8 --ip=192.168.4.254 --netmask=255.255.255.0 --gateway=0.0.0.0 --nameserver=192.168.4.254 --noipv6
network --hostname=ns1.example.com
auth --useshadow --enablemd5
services --enabled=NetworkManager,sshd,chronyd,dhcpd,unbound
eula --agreed
ignoredisk --only-use=sda
reboot --eject
bootloader --location=mbr
zerombr
clearpart --all --initlabel
part swap --asprimary --fstype="swap" --size=1024
part /boot --fstype xfs --size=512
part pv.01 --size=1 --grow
volgroup vg0 pv.01
logvol / --fstype xfs --name=lv_root --vgname=vg0 --size=1 --grow
rootpw "cangetin"
user --name=admin --groups=wheel --plaintext --password=welcome1
%packages --nobase --ignoremissing
@core  --nodefaults
wget
vim
unbound
dhcp
bzip2
kernel-devel
perl
gcc
-iwl*
-ply*
-postfix
-*-firmware
%end
%post --log=/root/postinstall.log
# install public access key for lab purposes
mkdir -p /home/admin/.ssh
chmod 700 /home/admin/.ssh
cat >  /home/admin/.ssh/authorized_keys << "EOF"
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP41JqHlPd+HNWENrJo6fStBy3967aYXE1/wEjtw5NwZ publicaccess-vlab44-ed25519-key-20181227
EOF
chmod 600 /home/admin/.ssh/authorized_keys
chown -R admin: /home/admin/.ssh
cat >> /etc/sudoers << "EOF"
admin        ALL=(ALL)       NOPASSWD: ALL
EOF
cat >> /etc/sysctl.d/98-user.conf <<"EOF"
## optional to decrease the use of swap
vm.swappiness = 1 
## essential for NAT
net.ipv4.ip_forward = 1
EOF
cat >>/etc/sysconfig/network-scripts/ifcfg-enp0s3 << "EOF"
ZONE=external
EOF
cat >>/etc/sysconfig/network-scripts/ifcfg-enp0s8 << "EOF"
ZONE=internal
EOF
systemctl disable kdump.service
systemctl enable tmp.mount
firewall-offline-cmd --zone=internal  --add-service=ntp
# generic localhost names
cat >> /etc/hosts << "EOF"
192.168.4.254 ns1.example.com ns1
EOF
sed -i.orig 's/\#allow 192.168.0.0\/16/allow 192.168.0.0\/16/' /etc/chrony.conf
cat >> /etc/vimrc << "EOF"
set background=dark
EOF
# utility script
echo -n "Utility scripts"
echo "== Utility scripts ==" >> /root/ks-post.debug.log
wget -O /var/tmp/ns1-config.sh https://piotraf.github.io/lab56/ns1-config.sh 2 >> /root/ks-post.debug.log 2&>1
chmod +x /var/tmp/ns1-config.sh
echo .
# remove unnecessary packages
echo -n "Removing unnecessary packages"
echo "== Removing unnecessary packages ==" >> /root/ks-post.debug.log
yum -C -y remove linux-firmware >> /root/ks-post.debug.log 2&>1
echo .
### 
sed -i.orig 's/# interface: 0.0.0.0$/interface: 0.0.0.0/g' /etc/unbound/unbound.conf
sed -i 's/\# access-control: 127.0.0.0\/8 allow/access-control: 192.168.0.0\/16 allow/g' /etc/unbound/unbound.conf
mv /etc/unbound/conf.d/example.com.conf{,.stub-zone}
cat >> /etc/unbound/conf.d/example.com.conf << "EOF"
server:
local-zone: "example.com." static
local-data: "ns1.example.com.  IN A 192.168.4.254"
local-data-ptr: "192.168.4.254  ns1.example.com"
local-data-ptr: "192.168.4.1  vbox.example.com"
local-data: "vbox.example.com.  IN A 192.168.4.1"
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
firewall-offline-cmd --zone=internal --add-service=dns
## create DHCP server for the LAB44
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




subnet 192.168.4.0 netmask 255.255.255.0 {
        option routers                  192.168.4.254;
        option subnet-mask              255.255.255.0;
        option domain-name-servers       192.168.4.254;
range 192.168.4.240 192.168.4.249;
host labipa {
     hardware ethernet 08:00:27:F8:65:38;
     fixed-address 192.168.4.200;
	}
}
host server1 {
     hardware ethernet 08:00:27:BB:C7:A2;
     fixed-address 192.168.4.210;
	}
}
host server2 {
     hardware ethernet 08:00:27:33:83:74;
     fixed-address 192.168.4.220;
	}
}
EOF
###
###
%end
#############################################################
