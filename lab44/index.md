# VirtualBox Lab44
## Creating the lab44 router with dhcp and dns server based on unbound
1. Create VM in VirtualBox with the following settings:
 * RAM size default: 1GB
 * Disk size default 8GB
 * Display/screen/graphics controller: VBoxVGA
 * Storage: Centos minimal iso as Optical drive
 * disable audio (optional)
 * disable usb (optional)
2. Start the VM and when the installation screen pops up, choose with arrows the Installation option and press TAB. This will display the initial boot command line. Append to it: 
```inst.ks=http://piotraf.github.io/lab44/ns1.ks```
and press Enter. Grab a cup of coffee and wait. :-)
3. While waiting:
* download https://piotraf.github.io/lab44/publicaccess-vlab44-ed25519-key-20181227.pub
* download https://piotraf.github.io/lab44/publicaccess-vlab44-ed25519-key-20181227.ppk
* configure your putty settings to:
  * ```ip: 192.168.44.254```
  * ```port: 22```
  * ```connection/data/auto-login username: admin```
  * ```connection/ssh/auth/private key authentication: path to the ppk```
  * save the session with whatever name you wish
 4. When VM is ready"
 * connect with the new putty connection
 * run:
  * ```sudo su -```
  * ```yum update -y```
  * proceed with steps: https://github.com/piotraf/piotraf.github.io/blob/master/lab44/ns1-config.sh
  
  
  
  
