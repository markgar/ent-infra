Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

$switchName = "InternalNAT"
New-VMSwitch -Name $switchName -SwitchType Internal
New-NetNat –Name $switchName –InternalIPInterfaceAddressPrefix “192.168.0.0/24”
$ifIndex = (Get-NetAdapter | ? {$_.name -like "*$switchName)"}).ifIndex
New-NetIPAddress -IPAddress 192.168.0.1 -InterfaceIndex $ifIndex -PrefixLength 24 


Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0