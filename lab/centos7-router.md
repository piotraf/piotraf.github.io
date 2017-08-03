# Centos 7 router minimal setup
###### pre-requisites:
Working copy of Centos 7 minimal installation with 2 network cards (in this example:
  _enp0s3_ and _enp0s8_) which are configured for internet (_enp0s3_) and local network (_enp0s8_).
###### steps:
All below commands to be executed as user: _root_.
```
cat >> /etc/sysctl.d/98-user.conf <<"EOF"
net.ipv4.ip_forward = 1
EOF
systemctl restart systemd-sysctl.service
```
optional verify if the value is 1:
```sysctl net.ipv4.ip_forward```

```
firewall-cmd --zone=external --add-interface=enp0s3 --permanent
firewall-cmd --zone=internal --add-interface=enp0s8 --permanent
firewall-cmd --complete-reload
```
