#Vagrant 1.6+ natively supports Windows guests over WinRM.
Vagrant.require_version ">= 1.6"

$domain = "marti.local" # Set example domain
$domain_ip_address = "192.168.56.2"
$timezone = "FLE Standard Time" # Bulgaria local time , use tzutil /l in PS to review the timezones

Vagrant.configure("2") do |config|

    config.vm.box = "StefanScherer/windows_2016"
    config.vm.define "windows-domain-controller"
    config.vm.hostname = "WindowsDC"

    #WinRM settings
    config.winrm.transport = :plaintext
    config.winrm.basic_auth_only = true
    config.vm.guest = :windows
    config.vm.communicator = "winrm"
    config.winrm.username  = "vagrant"
    config.winrm.password  = "vagrant"

    config.vm.network :private_network, ip: $domain_ip_address


    config.vm.network "forwarded_port", host: 33389, guest: 3389 #RDP
    config.vm.network "forwarded_port", host: 389, guest: 389 #LDAP
    config.vm.network "forwarded_port", host: 636, guest: 636 #LDAPS
    config.vm.network "forwarded_port", host: 88, guest: 88 # Kerberos


        # Configure VirtualBox
        config.vm.provider :virtualbox do |v|
            v.gui = true
            v.name = "WindowsDC"
            v.cpus = 2
            v.memory = 2048
            v.linked_clone = true
            v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        end    

    config.vm.synced_folder ".", "/vagrant"

    # Installing AD DS
    config.vm.provision "shell", path: "provision/domain-controller.ps1", args: [$domain]
    config.vm.provision "shell", reboot: true
    config.vm.provision "shell", path: "provision/domain-controller-configure.ps1"
    config.vm.provision "shell", reboot: true
    config.vm.provision "shell", path: "provision/base.ps1", args: [$timezone]
    config.vm.provision "shell", path: "provision/ad-explorer.ps1"


end