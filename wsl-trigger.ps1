Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "PANGP Virtual Ethernet Adapter"} | Set-NetIPInterface -InterfaceMetric 6000
