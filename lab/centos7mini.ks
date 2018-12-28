##############################################################
#                      centos7mini.ks                        #
##############################################################
install
text
cdrom
lang pl_PL.UTF-8
keyboard pl2
timezone Europe/Warsaw
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
cat >> /etc/sudoers << "EOF"
admin        ALL=(ALL)       NOPASSWD: ALL
EOF
%end
#############################################################
