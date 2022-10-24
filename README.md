# wsl2-globalprotect
A small repository to show a way to solve Windows Subsystem for Linux 2 how to co-exist with Palo Alto Networks Global Protect.

Windows has two versions of WSL or Windows Subsystem for Linux. The newer one WSL version 2 changes how connectivity happens, and a lot of VPNs has issues with this as connecting VPN breaks internet connectivity. Here is a way I found it possible to solve this issue. My understanding of the issue is basically a routing metric issue.

This test is done on:
- Microsoft Windows 10 version 10.0.19044.2130
- Global Protect version 6.0.3
- Debian 11 in WSL 

The solution consists of:

1 - Powershell script to change interface metric on the PANGP virtual interface
2 - A batch script to start the Powershell script
3 - Configuration of Global Protect to run this script each time Global Connect VPN connects.

1 - Powershell script

The script simply changes metric 



Orgin: https://github.com/microsoft/WSL/issues/5068#issuecomment-1268171185
