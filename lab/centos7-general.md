# Centos 7 - general notes

disable kdump
```bash
systemctl disable kdump.service
```
create swapfile e.g. 64M (64 * 1024 = 65536)

```bash
dd if=/dev/zero of=/swapfile bs=1024 count=65536
mkswap /swapfile
chmod 0600 /swapfile
swapon /swapfile
cp -v /etc/fstab{,.orig}
cat >>/etc/fstab<< "EOF"
/swapfile swap swap defaults 0 0
EOF
```
change vm.swapiness from default 60 to 10
```bash
cat >> /etc/sysctl.d/98-user.conf <<"EOF"
vm.swappiness = 10
EOF
systemctl restart systemd-sysctl.service
```
verify settings ```sysctl vm.swappiness```

optional enable tmpfs /tmp ```systemctl enable tmp.mount```
(requires reboot to be activated)
```bash
nmcli con mod enp0s8 ipv4.dns "192.168.111.1"
#nmcli con mod enp0s8 gw4 192.168.111.1
```
```bash
systemctl poweroff
systemctl reboot
systemctl --failed
```
```bash
yum update -y &&reboot
##echo nameserver 8.8.8.8>> /etc/resolv.conf
```
```javascript
var s = "JavaScript syntax highlighting";
alert(s);
```

```python
s = "Python syntax highlighting"
print s
```

```
No language indicated, so no syntax highlighting.
But let's throw in a <b>tag</b>.
```

var s = "JavaScript syntax highlighting";
alert(s);
