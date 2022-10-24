# wsl2-globalprotect
A small repository to show a way to solve Windows Subsystem for Linux 2 how to co-exist with Palo Alto Networks Global Protect.

Windows has two versions of WSL or Windows Subsystem for Linux. The newer one WSL version 2 changes how connectivity happens, and a lot of VPNs has issues with this as connecting VPN breaks internet connectivity. Here is a way I found it possible to solve this issue. My understanding of the issue is basically a routing metric issue.

This test is done on:
- Microsoft Windows 10 version 10.0.19044.2130
- Global Protect version 6.0.3
- Debian 11 in WSL 

The solution consists of:

## 1 - Powershell script 

To change interface metric on the PANGP virtual interface, so the WSL operative system can access internet outside the vpn tunnell.

Orgin: https://github.com/microsoft/WSL/issues/5068#issuecomment-1268171185

## 2 - A batch script to start the Powershell script

A simple script to run the powershell script. As the Powershell script was not possible to run from Global Protect VPN connect event, a workaround was found with triggering it from a batch file.

## 3 - Configuration of Global Protect to run this script each time Global Connect VPN connects.

Global Protect is capable of running a "Post VPN Connect" script as an admin user. To do so, one will have to create a new key named post-vpn-connect in  
HKEY_LOCAL_MACHINE\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings

And then add on a new string value "command" with the batch file (this is the batch file that triggers the PowerShell script)
and another string named "context" with value "admin" (this is to make the batch file be run as administrator).

An easy way is to import the "globalprotect-post-vpn-connect.reg" from this repositry after eventual edits.  

