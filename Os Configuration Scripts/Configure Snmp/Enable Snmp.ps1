<#
.SYNOPSIS
  This script can be used to configure Snmp
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
  List all parameters here
  $syscontact                 The person to contact for the system
  $syslocation                The rack location of the device
  $sysservices                Enables Physical Service, Applications Service, Datalink and subnetwork Service, Internet Service, End to End Service
  $enableauthtraps            (enables or disables snmp authentaction traps - better to leave disabled)
  $manager1                   The snmp managers of the device
  $manager2                   The snmp managers of the device
  $manager3                   The snmp managers of the device
  $trapreceiver1              The designated snmp trap receiver(s)
  $trapreceiver2              The designated snmp trap receiver(s)
  $trapreceiver3              The designated snmp trap receiver(s)
  $trapreceiver4              The designated snmp trap receiver(s)
  $communitystring            The snmp community string for the configuration
  $communitystringsecurity
  $errorlog
  $logfile
  $logfolder
.INPUTS
  List all inputs here
  $syscontact
  $syslocation # 
  $sysservices # 
  $enableauthtraps
  $manager1 
  $manager2
  $manager3
  $trapreceiver1 
  $trapreceiver2
  $trapreceiver3
  $trapreceiver4
  $communitystring
  $communitystringsecurity (the security level of the snmp community (read-only etc))
  $errorlog - the log that gets created on a trapped error
  $logfile - the log of the action and completion
  $logfolder - where the logs get created
.OUTPUTS
    Standard logfiles if enabled
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article

  For sysservices there are several levels
  "Applications, Internet, End-to-End (DEFAULT)" VALUE NUMERIC 76 DEFAULT
  "Physical, Applications, Internet, End-to-End" VALUE NUMERIC 77
  "Physical, Applications, Datalink and Subnetwork, Internet, End-to-End" VALUE NUMERIC 79 DEFAULT
  "Physical, Applications, End-to-End" VALUE NUMERIC 73

  For snmp security on the community name you have to select the type of community you want (read only etc)
  $readonly = "4"
  #$none = "1"
  #$notify = "2"
  #$readwrite = "8"
  #$readcreate = "16"
  
.EXAMPLE
  To add error logging add the following parameters from below
  .\enable snmp -manager1 (managername) -manager2 (managername) -manager3 (managername) -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>
Param(
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$syscontact,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$syslocation,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$sysservices,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$enableauthtraps,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$manager1,
	
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$manager2,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$manager3,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$trapreceiver1,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$trapreceiver2,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$trapreceiver3,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$trapreceiver4,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$communitystring,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$parameter1,

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

#Import ServerManger Module
Import-Module ServerManager

#Check If SNMP Services Are Already Installed
	$check = Get-WindowsFeature | Where-Object {$_.Name -eq "SNMP-Services"}
If ($check.Installed -ne "True") {
	Add-WindowsFeature SNMP-Service | Out-Null
}

Try {
  #setting the syscontact
  $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\RFC1156Agent" 
  #create the new community string path in the registry
  New-ItemProperty -Path $registryPath -Name "sysContact" -Value $syscontact
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
  #setting the syslocation
  $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\RFC1156Agent" 
  #create the new community string path in the registry
  New-ItemProperty -Path $registryPath -Name "sysLocation" -Value $sysLocation
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
  #setting the sysservices
  $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\RFC1156Agent" 
  #create the new community string path in the registry
  New-ItemProperty -Path $registryPath -Name "sysServices" -Value $sysServices
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

 #create first trap receiver
Try {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver1 
}

Catch {
  $error = $_.Exception 
  $ErrorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $Error
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $Error
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $error
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

#create second trap receiver
Try {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver2
}

Catch {
  $error = $_.Exception 
  $ErrorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $Error
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $Error
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $error
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

#create third trap receiver
Try {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver3
    #now to add the traps
}

Catch {
  $error = $_.Exception 
  $ErrorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $Error
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $Error
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $error
    Write-host "The error message is " $errormessage
    Write-host "The item that failed is " $faileditem
  }
    Break}

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

#create fourth trap receiver
Try {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver4
}

Catch {
  $error = $_.Exception 
  $ErrorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $Error
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $Error
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $error
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

#configure communities and the type
Try {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name $communitystring -Value $communitystringsecurity
}

Catch {
  $error = $_.Exception 
  $ErrorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $Error
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $Error
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $error
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
  #configure the permitted managers
  $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" 
  #create the new community string path in the registry
  New-ItemProperty -Path $registryPath -Name $manager -Value 1
}

Catch {
$error = $_.Exception 
$ErrorMessage = $_.Exception.Message
$FailedItem = $_.Exception.ItemName 

if (!$logfolder -and $errorlog)
{
  Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
  Add-Content $scriptdir\$errorlog "The error is " $Error
  Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
  Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
} elseif ($logfolder -and $errorlog) 
{
  Add-Content $logfolder\$errorlog "The error is " $Error
  Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
  Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
}
elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
{
  write-host "No error log specified outputting errors to the screen " 
  Write-host "The exception that occured is " $error
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
  #configure the permitted managers
  $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" 
  #create the new community string path in the registry
  New-ItemProperty -Path $registryPath -Name $manager1 -Value 2
}

Catch {
$error = $_.Exception 
$ErrorMessage = $_.Exception.Message
$FailedItem = $_.Exception.ItemName 

if (!$logfolder -and $errorlog)
{
  Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
  Add-Content $scriptdir\$errorlog "The error is " $Error
  Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
  Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
} elseif ($logfolder -and $errorlog) 
{
  Add-Content $logfolder\$errorlog "The error is " $Error
  Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
  Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
}
elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
{
  write-host "No error log specified outputting errors to the screen " 
  Write-host "The exception that occured is " $error
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
  #configure the permitted managers
  $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" 
  #create the new community string path in the registry
  New-ItemProperty -Path $registryPath -Name $manager2 -Value 3
}

Catch {
$error = $_.Exception 
$ErrorMessage = $_.Exception.Message
$FailedItem = $_.Exception.ItemName 

if (!$logfolder -and $errorlog)
{
  Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
  Add-Content $scriptdir\$errorlog "The error is " $Error
  Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
  Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
} elseif ($logfolder -and $errorlog) 
{
  Add-Content $logfolder\$errorlog "The error is " $Error
  Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
  Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
}
elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
{
  write-host "No error log specified outputting errors to the screen " 
  Write-host "The exception that occured is " $error
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

