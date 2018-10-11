#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to configure Snmp
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    $manager1
    $manager2
    $manager3
    $communitystring
    $trapreceiver1
    $trapreceiver2
    $trapreceiver3
    $trapreceiver4
    $errorlog
    $logfile
    $logfolder
.INPUTS
    List all inputs here
    $manager1
    $manager2
    $manager3
    $communitystring
    $trapreceiver1
    $trapreceiver2
    $trapreceiver3
    $trapreceiver4
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
  
.EXAMPLE
  To add error logging add the following parameters from below
  .\enable snmp -manager1 (managername) -manager2 (managername) -manager3 (managername) -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>
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
  [Parameter(Mandatory=$False,Position=1)]
  [string]$manager1,
	
  [Parameter(Mandatory=$False)]
  [string]$manager2,

  [Parameter(Mandatory=$False)]
  [string]$manager3,

  [Parameter(Mandatory=$False)]
  [string]$communitystring,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
)

#Import ServerManger Module
Import-Module ServerManager

#Check If SNMP Services Are Already Installed
	$check = Get-WindowsFeature | Where-Object {$_.Name -eq "SNMP-Services"}
If ($check.Installed -ne "True") {
	Add-WindowsFeature SNMP-Service | Out-Null
}

Try {
  if (!$communitystring) {
    Write-Host "No trap receiver specified moving on "
  } else {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name $name -Value $value 
  } 
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
#create first trap receiver
Try {
  if (!$trapreceiver1) {
    Write-Host "No trap receiver specified moving on "
  } else {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver1
  #now to add the traps
  }
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

#create second trap receiver
Try {
  if (!$trapreceiver2) {
    Write-Host "No trap receiver specified moving on "
  } else {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver2
  #now to add the traps
  }
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

#create third trap receiver
Try {
  if (!$trapreceiver3) {
    Write-Host "No trap receiver specified moving on "
  } else {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver3
  #now to add the traps
  }
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


#create fourth trap receiver
Try {
  if (!$trapreceiver4) {
    Write-Host "No trap receiver specified moving on "
  } else {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 1 -Value $trapreceiver4
  #now to add the traps
  }
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

#configure communities
Try {
  if (!$communitystring) {
    Write-Host "No community name specified moving on "
  } else {
    #map the community name above to a new registry key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities\$communityname" 
    #create the new community string path in the registry
    New-ItemProperty -Path $registryPath -Name 4 -Value $communitystring
  #now to add the traps
  }
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


