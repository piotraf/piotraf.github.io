##############################################################
#                   c8-ns1.ks template                       #
# append to the boot kernel line (use TAB):                  #
# inst.ks=http://piotraf.github.io/lab56/c8-ns1.ks           #
##############################################################
install
text
cdrom
lang pl_PL.UTF-8
keyboard pl2
timezone --utc Europe/Warsaw --ntpservers=0.pl.pool.ntp.org,1.pl.pool.ntp.org,2.pl.pool.ntp.org,3.pl.pool.ntp.org
network --onboot=yes --bootproto=dhcp --device=enp0s3 --nameserver=192.168.56.254 --ipv6=auto --activate
network --onboot=yes --bootproto=static --device=enp0s8 --ip=192.168.56.254 --netmask=255.255.255.0 --gateway=0.0.0.0 --nameserver=192.168.56.254 --noipv6
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
%packages --ignoremissing
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
%end
#############################################################
