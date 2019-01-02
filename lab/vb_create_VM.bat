DRAFT NOTES - DO NOT USE
; prerequisites - installed VirtualBox (tested on VirtualBox version 6.0.0 on Microsoft Windows 10)
; commands to be performed in CMD 
set PATH=%PATH%;"C:\Program Files\Oracle\VirtualBox"
; optional: set PATH=%PATH%;"C:\Program Files\7-Zip"
set VMNAME=test01
;VBoxManage list ostypes
VBoxManage createvm --name %VMNAME% --ostype "Redhat_64" --register
Virtual machine 'test01' is created and registered.
UUID: e.g. fd1e53b7-4830-417d-977d-8d40b516e816
Settings file: 'YOUR_DEFAULT_PATH\test01\test01.vbox'
VBoxManage storagectl %VMNAME% --name "IDE Controller" --add ide

==
VBoxManage unattended install "test02" --iso="D:\iso"/CentOS-7-x86_64-Minimal-1810.iso --extra-install-kernel-parameters="inst.ks=http://piotraf.github.io/lab/centos7mini.ks"

