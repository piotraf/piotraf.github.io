##############################################################
#                      centos6mini.ks template               #
# append to the boot kernel line (use TAB):                  #
# ks=http://piotraf.github.io/lab/c6rac1.ks ksdevice=eth0    #
##############################################################
install
text
cdrom
lang pl_PL.UTF-8
keyboard pl2
timezone Europe/Warsaw
auth --useshadow --enablemd5
services --enabled=sshd
network --bootproto=dhcp --device=eth0
firewall --disable
selinux --disable
ignoredisk --only-use=sda
reboot --eject
bootloader --location=mbr
zerombr
clearpart --all --initlabel
part swap --asprimary --fstype="swap" --size=1024
part /boot --fstype ext4 --size=200
part pv.01 --size=1 --grow
volgroup vg0 pv.01
logvol / --fstype ext4 --name=lv_root --vgname=vg0 --size=1 --grow
rootpw "cangetin"
user --name=admin --groups=wheel --plaintext --password=welcome1
%packages --nobase --ignoremissing
@core  --nodefaults
%end
%post --log=/root/postinstall.log
# install public access key for lab purposes
mkdir -p /home/admin/.ssh
chmod 700 /home/admin/.ssh
cat >  /home/admin/.ssh/authorized_keys << "EOF"
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA2YMUPsimi2gXkqm7DeF1j+Rw+wK9f/e3k9+OPw0uSH1T/0a8+vLIa70PJSSScmu1tXllqhuqvfmglmV6ZKGUJrATFV9azePW7/eIj8SsWvZ8ifm6JJYXJr4MMXSWPfogtZTxw6UPstXA9eoIX7BiuNCLQHs6WlWP4myUs9oMBytfLkbIUD2kd14Njkof5aJ0NQQkTh7iNRuxA0y0v+u4RCwaWHA3hF0qav0F8Js2EeS4B0JKzTLtLaO2Rh5i8biLQRADHmSDJrezk8onP/+fBX/i1h1pIAAyMmx1/ukyOmhwA4Gb+ZfCtbkZrdNXDyi28G0Ms+NMWIySNUx4stGW7w== virtualbox-publicly-accessible-rsa-key-20180630
EOF
chmod 600 /home/admin/.ssh/authorized_keys
chown -R admin: /home/admin/.ssh
#restorecon -R -v /home/admin/.ssh
cat >> /etc/sudoers << "EOF"
admin        ALL=(ALL)       NOPASSWD: ALL
EOF
cat >> /etc/sysctl.conf <<"EOF"
## optional to decrease the use of swap
vm.swappiness = 10 
EOF
reboot
%end
#############################################################
