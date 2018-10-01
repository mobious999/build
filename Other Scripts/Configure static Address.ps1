#$ip_address = Read-Host("What's the IP address? :")
$ipaddress = "10.145.15.3"
$subnetmask = "22"
$gateway = "10.145.15.1"
$suffixes = 'iso-ne.com', 'iso-dev.com' 
$nic = Get-NetAdapter -physical | where status -eq 'up'
Get-NetAdapter -physical | where status -eq 'up' | Rename-NetAdapter -NewName Renamed
Get-NetAdapter -physical | where status -eq 'up' | Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -RegisterThisConnectionsAddress:$False -UseSuffixWhenRegistering:$true -Verbose
Get-NetAdapter -physical | where status -eq 'up' | Set-DnsClientServerAddress -ServerAddresses 192.168.1.2,8.8.8.8,8.8.4.4
Get-NetAdapter -physical | where status -eq 'up' | New-NetIPAddress -IPAddress $ipaddress -PrefixLength $subnetmask -DefaultGateway $gateway
Set-DnsClientGlobalSetting -SuffixSearchList @("corp.contoso.com", "na.corp.contoso.com")
$adapter = Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"'
$adapter.SetTcpIPNetbios(1) 
Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | % {$_.SetWINSServer("172.16.1.240","172.16.1.241")}