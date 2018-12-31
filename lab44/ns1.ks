##############################################################
#                      ns1.ks template                       #
# append to the boot kernel line (use TAB):                  #
# inst.ks=http://piotraf.github.io/lab44/ns1.ks              #
##############################################################
install
text
cdrom
lang pl_PL.UTF-8
keyboard pl2
timezone --utc Europe/Warsaw
network --onboot=yes --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network --onboot=yes --device=enp0s8 --bootproto=static --ip=192.168.44.254 --netmask=255.255.255.0 --gateway=0.0.0.0 --nameserver=8.8.8.8 --noipv6
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
part /boot --fstype xfs --size=200
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
vm.swappiness = 10 
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
reboot
%end
#############################################################
