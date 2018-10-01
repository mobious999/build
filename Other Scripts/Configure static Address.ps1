#requires -version 2
<#
.SYNOPSIS
  This script can be used to ip address of the device to static variables
.DESCRIPTION
  This script will ip the first network card that is connected to the network
.PARAMETER <Parameter_Name>
    Required fields 
    Ip address of the device
.INPUTS
    Ip address of the device
.OUTPUTS
    all errors go to c:\buildlog
    an error log will be generated if there are errors.   
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  This script is base on this article
  https://docs.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress?view=win10-ps
  https://docs.microsoft.com/en-us/powershell/module/nettcpip/New-NetIPAddress?view=win10-ps
  Dynamic dns registration (the checkbox) is controlled by the -RegisterThisConnectionsAddress:$False (see below)
  Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -RegisterThisConnectionsAddress:$False -UseSuffixWhenRegistering:$true -Verbose
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>

$ipaddress = Read-Host("What's the IP address? :")
#the below referenced subnet mask is in cidr notation
#for example 255.255.255.0 = /24
#for example 255.255.254.0 = /23 
#for example 255.255.252.0 = /22
$logfolder = "c:\buildlog"
If(Test-Path $logfolder)
  	{
	    #write-host "path exists"
	}
else 
	{
		#Write-Host "path doesn't exist"
		#if the path doesn't exist create it
		New-Item -ItemType Directory -Path $logfolder
    }
  
$errorlog = "c:\buildlog\error.log"
$subnetmask = "22"
$gateway = "x.x.x.x"
$dnssuffix = "domain.com"
$dnsserver1 = "x.x.x.x"
$dnsserver2 = "x.x.x.x"
$dnssuffix1 = "corp.contoso.com"
$dnssuffix2 = "na.corp.contoso.com"
$winsserver1 = "x.x.x.x"
$winsserver2 = "x.x.x.x"
$nicname = "name of network adapter"
$nic = Get-NetAdapter -physical | where-object status -eq 'up'

Try {
    #attempting to rename the adapter to 
    Get-NetAdapter -physical | where-object status -eq 'up' | Rename-NetAdapter -NewName $nicname
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to rename the adpater" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
    write-host $nic "configured correctly"
}


Try {
    # attempt to set the dns suffix
    Get-NetAdapter -physical | where-object status -eq 'up' | Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -RegisterThisConnectionsAddress:$False -UseSuffixWhenRegistering:$true -Verbose
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to to set the dns suffix" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
    # Always run this at the end
}

Try {
    #Attempt to set the dns servers
    Get-NetAdapter -physical | where-object status -eq 'up' | Set-DnsClientServerAddress -ServerAddresses $dnsserver1,$dnsserver2
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to set the dns servers" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
 # Always run this at the end
}

Try {
    #attempt to set the network address for the connected network card
    Get-NetAdapter -physical | where-object status -eq 'up' | New-NetIPAddress -IPAddress $ipaddress -PrefixLength $subnetmask -DefaultGateway $gateway
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to set the network address for the connected network card" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
     # Always run this at the end
}

Try {
    #attempt to set the dns suffix search order
    Set-DnsClientGlobalSetting -SuffixSearchList @($dnssuffix1, $dnssuffix2)
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to set the dns suffix search order" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
    # Always run this at the end
}


Try {
    #attempt to set the (enable netbios option to enabled)
    $adapter = Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"'
    $adapter.SetTcpIPNetbios(1) 
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to set the (enable netbios option to enabled)" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
     # Always run this at the end
}

Try {
    #attempt to set the wins servers if required
    Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | % {$_.SetWINSServer($winsserver1,$winsserver2)}
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to set the wins servers" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
     # Always run this at the end
}

#this section is used for reference to validate commands
#Get-NetAdapter -physical | where status -eq 'up' | Rename-NetAdapter -NewName Renamed
#Get-NetAdapter -physical | where status -eq 'up' | Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -RegisterThisConnectionsAddress:$False -UseSuffixWhenRegistering:$true -Verbose
#Get-NetAdapter -physical | where status -eq 'up' | Set-DnsClientServerAddress -ServerAddresses $dnsserver1,$dnsserver2
#Get-NetAdapter -physical | where status -eq 'up' | New-NetIPAddress -IPAddress $ipaddress -PrefixLength $subnetmask -DefaultGateway $gateway
#Set-DnsClientGlobalSetting -SuffixSearchList @("corp.contoso.com", "na.corp.contoso.com")
#Set-DnsClientGlobalSetting -SuffixSearchList @($dnssuffix1, $dnssuffix2)
#$adapter = Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"'
#$adapter.SetTcpIPNetbios(1) 
#Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | % {$_.SetWINSServer("172.16.1.240","172.16.1.241")}
#Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | % {$_.SetWINSServer($winsserver1,$winsserver2)}