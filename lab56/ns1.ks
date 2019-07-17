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
timezone --utc Europe/Warsaw
network --onboot=yes --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network --onboot=yes --bootproto=static --device=enp0s8 --ip=192.168.56.254 --netmask=255.255.255.0 --gateway=0.0.0.0 --nameserver=8.8.8.8 --noipv6
network --hostname=ns1.example.com
auth --useshadow --enablemd5
services --enabled=NetworkManager,sshd
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
# generic localhost names
cat >> /etc/hosts << "EOF"
192.168.56.254 ns1.example.com ns1
# utility script
echo -n "Utility scripts"
echo "== Utility scripts ==" >> /root/ks-post.debug.log
wget -O /var/tmp/test.sh https://piotraf.github.io/lab56/ns1.ks 2 >> /root/ks-post.debug.log 2&>1
chmod +x /var/tmp/test.sh
echo .
# remove unnecessary packages
echo -n "Removing unnecessary packages"
echo "== Removing unnecessary packages ==" >> /root/ks-post.debug.log
yum -C -y remove linux-firmware >> /root/ks-post.debug.log 2&>1
echo .
%end
#############################################################
