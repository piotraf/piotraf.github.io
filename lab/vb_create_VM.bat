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

VBoxManage.exe: info: Preparing unattended installation of RedHat_64 in machine 'test02' (ef191167-f5ba-4312-b6bd-5d05204a0248).
VBoxManage.exe: info: Using values:
                           isoPath = D:\iso\CentOS-7-x86_64-Minimal-1810.iso
                              user = vboxuser
                          password = changeme
                      fullUserName =
                        productKey =
                  additionsIsoPath = C:\Program Files\Oracle\VirtualBox/VBoxGuestAdditions.iso
             installGuestAdditions = false
              validationKitIsoPath =
            installTestExecService = false
                            locale = en_US
                           country = PL
                          timeZone = Central Europe Standard Time
                             proxy =
                          hostname = test02.myguest.virtualbox.org
       packageSelectionAdjustments =
                 auxiliaryBasePath = D:\VirtualBoxVMs\SYSTEM\test02\Unattended-ef191167-f5ba-4312-b6bd-5d05204a0248-
                        imageIndex = 1
                scriptTemplatePath = C:\Program Files\Oracle\VirtualBox\UnattendedTemplates\redhat67_ks.cfg
     postInstallScriptTemplatePath = C:\Program Files\Oracle\VirtualBox\UnattendedTemplates\redhat_postinstall.sh
                postInstallCommand =
      extraInstallKernelParameters = inst.ks=http://piotraf.github.io/lab/centos7mini.ks
                          language = en-US
                  detectedOSTypeId = RedHat_64
                 detectedOSVersion = 7
                  detectedOSFlavor =
               detectedOSLanguages = en-US
                   detectedOSHints =
VBoxManage.exe: info: VM 'test02' (ef191167-f5ba-4312-b6bd-5d05204a0248) is ready to be started (e.g. VBoxManage startvm).
VBoxManage startvm "test02"
Waiting for VM "test02" to power on...
VM "test02" has been successfully started.
