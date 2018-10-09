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
    Standard output if logging is enabled
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  This script is base on this article
  https://docs.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress?view=win10-ps
  https://docs.microsoft.com/en-us/powershell/module/nettcpip/New-NetIPAddress?view=win10-ps
  https://support.microsoft.com/en-us/help/299540/an-explanation-of-the-automatic-metric-feature-for-ipv4-routes
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

Param(
  [Parameter(Mandatory=$true,Position=1)]
  [string]$ipaddress,
  [Parameter(Mandatory=$true)]
  [string]$subnetmask,
  [Parameter(Mandatory=$true)]
  [string]$gateway,
  [Parameter(Mandatory=$False)]
  [string]$dnssuffix,
  [Parameter(Mandatory=$False)]
  [string]$dnsserver1,
  [Parameter(Mandatory=$False)]
  [string]$dnsserver2,
  [Parameter(Mandatory=$False)]
  [string]$dnssuffix1,
  [Parameter(Mandatory=$False)]
  [string]$dnssuffix2,
  [Parameter(Mandatory=$False)]
  [string]$winsserver1,
  [Parameter(Mandatory=$False)]
  [string]$winsserver2,
  [Parameter(Mandatory=$False)]
  [string]$nicname,
  [Parameter(Mandatory=$False)]
  [string]$errorlog,
  [Parameter(Mandatory=$False)]
  [string]$logfile,
  [Parameter(Mandatory=$False)]
  [string]$logfolder
)    
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
    if (!$logfolder -or $logfolder) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        Add-Content $logfolder\$logfile "The action completed succesfully."
    } 
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
    if (!$logfolder -or $logfolder) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        Add-Content $logfolder\$logfile "The action completed succesfully."
      } 
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
    if (!$logfolder -or $logfolder) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        Add-Content $logfolder\$logfile "The action completed succesfully."
      } 
}

Try {
    #attempt to set the network address for the connected network card
    Get-NetAdapter -physical | where-object status -eq 'up' | New-NetIPAddress -IPAddress $ipaddress -PrefixLength $subnetmask -DefaultGateway $gateway
}

Catch {
    if (!$logfolder -or $errorlog) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Add-Content $logfolder\$errorlog "The configuration failed the error is " $ErrorMessage
        Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
      } 
        Break
}
Finally {
    if (!$logfolder -or $logfolder) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        Add-Content $logfolder\$logfile "The action completed succesfully."
      } 
}

Try {
    #attempt to set the dns suffix search order
    Set-DnsClientGlobalSetting -SuffixSearchList @($dnssuffix1, $dnssuffix2)
}

Catch {
    if (!$logfolder -or $errorlog) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Add-Content $logfolder\$errorlog "The configuration failed the error is " $ErrorMessage
        Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
      } 
        Break
}

Finally {
    if (!$logfolder -or $logfolder) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        Add-Content $logfolder\$logfile "The action completed succesfully."
      } 
}

Try {
    #attempt to set the (enable netbios option to enabled)
    $adapter = Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"'
    $adapter.SetTcpIPNetbios(1) 
}

Catch {
    if (!$logfolder -or $errorlog) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Add-Content $logfolder\$errorlog "The configuration failed the error is " $ErrorMessage
        Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
      } 
    Break
}
Finally {
    if (!$logfolder -or $logfolder) {
      Write-Host "No logfile or log folder specified no logging will be created"
    } else {
      Add-Content $logfolder\$logfile "The action completed succesfully."
    } 
}  

Try {
  Set-DnsClientGlobalSetting -SuffixSearchList @($dnssuffix1, $dnssuffix2)
}

Catch {
 if (!$logfolder -or $errorlog) {
   Write-Host "No logfile or log folder specified no logging will be created"
 } else {
   $ErrorMessage = $_.Exception.Message
   $FailedItem = $_.Exception.ItemName
   Add-Content $logfolder\$errorlog "The configuration failed the error is " $ErrorMessage
   Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
 } 
   Break
}

Finally {
 if (!$logfolder -or $logfolder) {
   Write-Host "No logfile or log folder specified no logging will be created"
 } else {
   Add-Content $logfolder\$logfile "The action completed succesfully."
 } 
}

Try {
    #attempt to set the wins servers if required
    Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | Each-Object {$_.SetWINSServer($winsserver1,$winsserver2)}
}

Catch {
    if (!$logfolder -or $errorlog) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Add-Content $logfolder\$errorlog "The configuration failed the error is " $ErrorMessage
        Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
      } 
    Break
}

Finally {
    if (!$logfolder -or $logfolder) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        Add-Content $logfolder\$logfile "The action completed succesfully."
      } 
}

Try {
  Set-NetIPInterface -InterfaceAlias $nicname -InterfaceMetric 1  
}

Catch {
 if (!$logfolder -or $errorlog) {
   Write-Host "No logfile or log folder specified no logging will be created"
 } else {
   $ErrorMessage = $_.Exception.Message
   $FailedItem = $_.Exception.ItemName
   Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
   Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
 } 
 Break
}

Finally {
 if (!$logfolder -or $logfolder) {
   Write-Host "No logfile or log folder specified no logging will be created"
 } else {
   Add-Content $logfolder\$logfile "The action completed succesfully."
 } 
}



#this section is used for reference to validate commands
#$nic = Get-NetAdapter -physical | where-object status -eq 'up'
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
#nic binding order
#Get-NetIPInterface -AddressFamily IPv4 -InterfaceAlias "<name of network adapter>"
#Set-NetIPInterface -InterfaceAlias "LAN" -InterfaceMetric 1  
