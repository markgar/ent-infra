Install-WindowsFeature -Name DHCP,Hyper-V  –IncludeManagementTools

$switchName = "InternalNAT"
New-VMSwitch -Name $switchName -SwitchType Internal
New-NetNat –Name $switchName –InternalIPInterfaceAddressPrefix “192.168.0.0/24”
$ifIndex = (Get-NetAdapter | Where-Object {$_.name -like "*$switchName)"}).ifIndex
New-NetIPAddress -IPAddress 192.168.0.1 -InterfaceIndex $ifIndex -PrefixLength 24 

Add-DhcpServerV4Scope -Name "DHCP-$switchName" -StartRange 192.168.0.50 -EndRange 192.168.0.100 -SubnetMask 255.255.255.0
Set-DhcpServerV4OptionValue -Router 192.168.0.1 -DnsServer 168.63.129.16
Restart-service dhcpserver

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0