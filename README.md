# Problem statement

Microsoft Windows has an easy accessible Linux capability with Windows Subsystem for Linux (WSL). Later a new version of WSL, version 2 has been implemented and this do not work well with VPN clients in general. For Palo Alto Networks Global Protect VPN client there are two issues adressed here:

First when connecting Global Protect VPN connection the internet connectivity of the WSL2 guest operative system goes away. Below is shown how one can reconnect this, and automate how to reconnect this each time the Global Connect client connects to VPN.

Both issues seems to be routing metric issues.

# 1. Internet connectivity

This test is done on:
- Microsoft Windows 10 version 10.0.19044.2130
- Global Protect version 6.0.3 for Windows
- Debian 11 in WSL 

The solution consists of three parts:

## a - Powershell script 

To change interface metric on the PANGP virtual interface, so the WSL operative system can access internet outside the vpn tunell. The script is named wsl-trigger.ps1 in this registry.

[Orgin](https://github.com/microsoft/WSL/issues/5068#issuecomment-1268171185)

## b - A batch script to start the Powershell script

A simple script named wsl-trigger.bat to run the powershell script. As the Powershell script was not possible to run from Global Protect VPN connect event, a workaround was found with triggering it from a batch file.

[Orgin](https://www.howtogeek.com/204088/how-to-use-a-batch-file-to-make-powershell-scripts-easier-to-run/)

## c - Configuration of Global Protect 

Global Protect is capable of running a "Post VPN Connect" script as an admin user. To do so, one will have to create a new key named post-vpn-connect in 

HKEY_LOCAL_MACHINE\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings

And then add on a new string named "command" with the batch file as value (this is the batch file that triggers the PowerShell script)
and another string named "context" with value "admin" (this is to make the batch file be run as administrator).

An easy way to do this is to save the script files in c:/tmp and import the Windows registry the "globalprotect-post-vpn-connect.reg" from this repositry to create the right settings.  

[Documentation 1](https://docs.paloaltonetworks.com/globalprotect/9-1/globalprotect-admin/globalprotect-apps/deploy-app-settings-transparently/deploy-app-settings-to-windows-endpoints/deploy-scripts-using-the-windows-registry#id3084dca9-6653-47b8-8154-598a4099049d) 

[Documentation 2](https://docs.paloaltonetworks.com/globalprotect/9-1/globalprotect-admin/globalprotect-apps/deploy-app-settings-transparently/customizable-app-settings/script-deployment-options)


# 2. VPN Connectivity

If one like to have the WSL2 guest operative system use Global Protect for connectivity to internal resources, a way to do so is installing the Global Protect client inside the guest operating system. It worked for me doing it so as below for Global Protect 6.0.1 for Linux. 
## a Install Global Protect

Fetch a copy if the Global Protect client for Linux, and install it. [Documentation](https://docs.paloaltonetworks.com/globalprotect/5-1/globalprotect-app-user-guide/globalprotect-app-for-linux/use-the-globalprotect-app-for-linux)

```
tar zxvf PanGPLinux-6.0.1-c6.tgz
tar xzvf GlobalProtect_tar-6.0.1.1-6.tgz
sudo ./install.sh
```
## b Change metrics on the default route

It looks like the default metrics is too high for the default route for the vpn route to take over. This is how to handle this manually on the Debian used in this example. Automation will be dependent of the distribution used for WSL2 guest. 

```
sudo ip route del default via 172.18.128.1
sudo ip route add default via 172.18.128.1 metric 100
```
 

## c Connect to vpn
```
globalprotect connect --portal vpn.example.com
```

Profit...
