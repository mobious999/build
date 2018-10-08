#requires -version 2
<#
.SYNOPSIS
  This script is the first of 3 parts that build a standard domain conroller for windows
.DESCRIPTION
  Computer Name will be changed to dc01
.PARAMETER <Parameter_Name>
  Required filds
	ip address informatin
  $ipaddress
  $subnetmask
  $gateway
  $policy
  $computer
  $errorlog - the log that gets created on a trapped error
  $logfile - the log of the action and completion
  $logfolder - where the logs get created
.INPUTS
    Not really required but tailor them to your environment
.OUTPUTS
  All logging goes to c:\adbuild.txt
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  7/29/2018
  Purpose/Change: Initial script development
  
.EXAMPLE
  Copy the file to the host and begin the configuraton
#>
Param(
  [Parameter(Mandatory=$False,Position=1)]
  [string]$Policy,
	
  [Parameter(Mandatory=$False)]
  [string]$ipaddress,

  [Parameter(Mandatory=$False)]
  [string]$subnetmask,
  [Parameter(Mandatory=$False)]
  [string]$gateway,
  [Parameter(Mandatory=$False)]
  [string]$Policy,
  [Parameter(Mandatory=$False)]
  [string]$computer,
  [Parameter(Mandatory=$False)]
  [string]$nicname,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
)

If(Test-Path $LogPath)
  	{
	    #write-host "path exists"
	}
else 
	{
		#Write-Host "path doesn't exist"
		#if the path doesn't exist create it
		New-Item -ItemType Directory -Path $LogPath
	}



Try {
  $Policy = "RemoteSigned"
  If ((get-ExecutionPolicy) -ne $Policy) {
    Set-ExecutionPolicy $Policy -Force
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

Try {
  #disable ipv6 
  New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\' -Name  'DisabledComponents' -Value '0xffffffff' -PropertyType 'DWord' 
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

Try {
  Get-NetAdapter -physical | where status -eq 'up' | Rename-NetAdapter -NewName $nicname
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

Try {
  #rename the computer
  Rename-Computer -NewName $computer –force 
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

Try {
  $addsTools = "RSAT-AD-Tools" 
  Add-WindowsFeature $addsTools 
  Get-WindowsFeature | Where-Object installed >>$LogPath\$logfile
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

Restart-Computer   