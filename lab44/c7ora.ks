##############################################################
#                      c7ora.ks template                     #
# append to the boot kernel line (use TAB):                  #
# inst.ks=http://piotraf.github.io/lab44/c7ora.ks            #
##############################################################
install
text
cdrom
lang pl_PL.UTF-8
keyboard pl2
timezone --utc Europe/Warsaw
auth --useshadow --enablemd5
services --enabled=NetworkManager,sshd
eula --agreed
ignoredisk --only-use=sda
reboot --eject
bootloader --location=mbr
zerombr
clearpart --all --initlabel
part swap --asprimary --fstype="swap" --size=4096
part /boot --fstype xfs --size=1024
part pv.01 --size=1 --grow
volgroup vg0 pv.01
logvol / --fstype xfs --name=lv_root --vgname=vg0 --size=10240
logvol /u01 --fstype xfs --name=lv_u01 --vgname=vg0 --size=10240 --grow
rootpw "cangetin"
user --name=admin --groups=wheel --plaintext --password=welcome1
%packages --nobase --ignoremissing
@core  --nodefaults
bzip2
kernel-devel
gcc
elfutils-libelf-devel
libaio-devel
unixODBC-devel
ksh
compat-libstdc++-33
xorg-x11-xinit
xterm
gcc-c++
libstdc++-devel
sysstat
libXtst
glibc-devel
glibc-headers
compat-libcap1
unzip
-audit
-btrfs-progs
-plymouth
-NetworkManager-team
-NetworkManager-tui
-NetworkManager-libnm
-NetworkManager-wifi
-dracut-config-rescue
-*-firmware
-iwl*
-kernel-tools
-linux-firmware
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
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
useradd -u 54321 -d /home/oracle -m -s /bin/bash -g oinstall -G dba,oper oracle
echo welcome1 | passwd --stdin oracle
cat >> /etc/sysctl.conf <<"EOF"
## oracle
vm.swappiness = 1 
kernel.shmmni = 4096 
kernel.shmmax = 4398046511104
kernel.shmall = 1073741824
kernel.sem = 250 32000 100 128
fs.aio-max-nr = 1048576
fs.file-max = 6815744
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048586
EOF
cat >> /etc/security/limits.conf <<"EOF"
oracle   soft   nproc    131072
oracle   hard   nproc    131072
oracle   soft   nofile   131072
oracle   hard   nofile   131072
oracle   soft   core     unlimited
oracle   hard   core     unlimited
oracle   soft   memlock  50000000
oracle   hard   memlock  50000000
EOF

systemctl disable kdump.service
systemctl mask tmp.mount
reboot
%end
#############################################################
