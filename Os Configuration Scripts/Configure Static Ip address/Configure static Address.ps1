<#
.SYNOPSIS
  This script can be used to ip address of the device to static variables
.DESCRIPTION
  This script will ip the first network card that is connected to the network

  The netowork card will be renamed as part of the configuration (a requirement to be able to adjust some of the settings)

  The intent is to be able to configure all network settings through one paramater line
  The subnet mask is configured using cidr notation
  #for example 255.255.255.0 = /24
  #for example 255.255.254.0 = /23 
  #for example 255.255.252.0 = /22

  The nic binding order will also be set for the device

.PARAMETER <Parameter_Name>
  Required fields are ipaddress subnetmask and gateway 
  $ipaddress                          - the ip address to assign
  $subnetmask                         - the subnet mask in cidr notation
  $gateway                            - the default gateway
  $dnssuffix                          - The dns suffix for the connection      
  $dnsserver                          - First dns server
  $dnsserver2                         - Second dns server
  $dnssuffix1                         - First dns suffix to append to this connection
  $dnssuffix2                         - Second dns suffix to append to this connection
  $winsserver1                        - Wins server number 1
  $winsserver2                        - Wins server number 2
  $nicname                            - Name of the network card - used for adjusting binding order
  $Register                           - The checkmark for register this connection in dns
  $UseSuffix                          - The checkmark for use dns suffix when registering
.INPUTS
  Ip address of the device
  $ipaddress
  $subnetmask
  $gateway
  $dnssuffix
  $dnsserver
  $dnsserver2
  $dnssuffix1
  $dnssuffix2
  $winsserver1
  $winsserver2
  $nicname
  $Register
  $UseSuffix
.OUTPUTS
  Standard output if logging is enabled
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  #this section is used for reference to validate commands
  #$nic = Get-NetAdapter -physical | where-object status -eq 'up'
  #set the ip address
  #Get-NetAdapter -physical | where status -eq 'up' | New-NetIPAddress -IPAddress $ipaddress -PrefixLength $subnetmask -DefaultGateway $gateway
  #rename the network card
  #Get-NetAdapter -physical | where status -eq 'up' | Rename-NetAdapter -NewName Renamed
  #configure the dns suffix and options
  #Get-NetAdapter -physical | where status -eq 'up' | Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -RegisterThisConnectionsAddress:$False -UseSuffixWhenRegistering:$true -Verbose
  #set the dns servers
  #Get-NetAdapter -physical | where status -eq 'up' | Set-DnsClientServerAddress -ServerAddresses $dnsserver1,$dnsserver2
  #Set dns suffix search order
  #Set-DnsClientGlobalSetting -SuffixSearchList @("corp.contoso.com", "na.corp.contoso.com")
  #Set-DnsClientGlobalSetting -SuffixSearchList @($dnssuffix1, $dnssuffix2)
  #Enable netbios checkbox
  #$adapter = Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"'
  #$adapter.SetTcpIPNetbios(1) 
  #Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | % {$_.SetWINSServer("172.16.1.240","172.16.1.241")}
  #Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | % {$_.SetWINSServer($winsserver1,$winsserver2)}
  #nic binding order
  #Get-NetIPInterface -AddressFamily IPv4 -InterfaceAlias "<name of network adapter>"
  #Set-NetIPInterface -InterfaceAlias "LAN" -InterfaceMetric 1  
  
.LINK
  This script is base on this article
  https://docs.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress?view=win10-ps
  https://docs.microsoft.com/en-us/powershell/module/nettcpip/New-NetIPAddress?view=win10-ps
  https://support.microsoft.com/en-us/help/299540/an-explanation-of-the-automatic-metric-feature-for-ipv4-routes
  Dynamic dns registration (the checkbox) is controlled by the -RegisterThisConnectionsAddress:$False (see below)
  Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -RegisterThisConnectionsAddress:$False -UseSuffixWhenRegistering:$true -Verbose

.EXAMPLE
  Copy the file to the host and begin the Configuration
#>

Param(
  [Parameter(Mandatory=$true,Position=1)]
  [ValidateNotNull()]
  [string]$ipaddress,

  [Parameter(Mandatory=$true)]
  [ValidateNotNull()]
  [string]$subnetmask,

  [Parameter(Mandatory=$true)]
  [ValidateNotNull()]
  [string]$gateway,

  [Parameter(Mandatory=$true)]
  [ValidateNotNull()]
  [string]$dnssuffix,

  [Parameter(Mandatory=$true)]
  [ValidateNotNull()]
  [string]$dnsserver1,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$dnsserver2,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$dnssuffix1,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$dnssuffix2,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$winsserver1,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$winsserver2,

  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [string]$nicname,

  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [bool]$Register,

  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [bool]$UseSuffix,
  
  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
) 

#capture where the script is being run from
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

#If logfolder is specified the directory will be created
if ($logfolder){
  If(Test-Path $logfolder){
  }  else {
      New-Item -ItemType Directory -Path $logfolder
  }
}

Try {
  #attempt to set the network address for the connected network card
  Get-NetAdapter -physical | where-object status -eq 'up' | New-NetIPAddress -IPAddress $ipaddress -PrefixLength $subnetmask -DefaultGateway $gateway
}

Catch {
$myerror = $_.Exception 
$errorMessage = $_.Exception.Message
$FailedItem = $_.Exception.ItemName 

if (!$logfolder -and $errorlog)
{
  Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
  Add-Content $scriptdir\$errorlog "The error is " $myError
  Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
  Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
} elseif ($logfolder -and $errorlog) 
{
  Add-Content $logfolder\$errorlog "The error is " $myError
  Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
  Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
}
elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
{
  write-host "No error log specified outputting errors to the screen " 
  Write-host "The exception that occured is " $myerror
  Write-host "The error message is " $errormessage
  Write-host "The item that fialed is " $faileditem
}
  Break
}
Finally {
if (!$logfolder -and $logfile) 
{
  #Write-host "No logfolder specified logs will be created locally if requested"   	
  Add-Content $ScriptDir\$logfile "The action completed succesfully."   
}
elseif ($logfolder -and $logfile)
{
  Add-Content $logfolder\$logfile "The action completed succesfully."   
}
elseif ([string]::IsNullOrWhiteSpace($logfile)) 
{
  #Write-host "logfile not specified"
  write-host "The command completed successfully"   
}
}

Try {
    #attempting to rename the adapter to $nicname
    Get-NetAdapter -physical | where-object status -eq 'up' | Rename-NetAdapter -NewName $nicname
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
    Break
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}

Try {
    # attempt to set the dns suffix
    Get-NetAdapter -physical | where-object status -eq 'up' | Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -RegisterThisConnectionsAddress:$Register -Verbose
    Get-NetAdapter -physical | where-object status -eq 'up' | Set-DnsClient -ConnectionSpecificSuffix $dnssuffix -UseSuffixWhenRegistering:$UseSuffix -Verbose
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that failed is " $faileditem
  }
  Break
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}

Try {
  #Attempt to set the dns servers
  if ($dnsserver1 -and $dnsserver2) {
    Get-NetAdapter -physical | where-object status -eq 'up' | Set-DnsClientServerAddress -ServerAddresses $dnsserver1,$dnsserver2
  } 
  elseif ($dnsserver1 -and !$dnsserver2){
    Get-NetAdapter -physical | where-object status -eq 'up' | Set-DnsClientServerAddress -ServerAddresses $dnsserver1
  }  
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
  Break
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}

Try {
    #attempt to set the dns suffix search order
    Set-DnsClientGlobalSetting -SuffixSearchList @($dnssuffix1, $dnssuffix2)
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}

Try {
    #attempt to set the (enable netbios option to enabled)
    $adapter = Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"'
    $adapter.SetTcpIPNetbios(1) 
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that failed is " $faileditem
  }
  Break
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}  

Try {
  Set-DnsClientGlobalSetting -SuffixSearchList @($dnssuffix1, $dnssuffix2)
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
  Break
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}

Try {
    #attempt to set the wins servers if required
    if ($winsserver1 -and $winsserver1){
      Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | Each-Object {$_.SetWINSServer($winsserver1,$winsserver2)}
    } elseif ($winsserver1 -and !$winsserver1) {
      Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"' | Each-Object {$_.SetWINSServer($winsserver1)}
    }
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
  Break
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}

Try {
  Set-NetIPInterface -InterfaceAlias $nicname -InterfaceMetric 1  
}

Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
  Break
}

Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}



