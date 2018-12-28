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
volgroup rootvg01 pv.01
logvol / --fstype xfs --name=lv01 --vgname=rootvg01 --size=1 --grow
rootpw "cangetin"
%packages --nobase --ignoremissing
@core  --nodefaults
-iwl*
%end
#############################################################
