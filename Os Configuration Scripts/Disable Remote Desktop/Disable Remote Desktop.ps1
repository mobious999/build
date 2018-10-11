#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to Disable remote desktop
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    $errorlog
    $logfile
    $logfolder
.INPUTS
    List all inputs here
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
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
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
  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
)


Try {
  #set the enable remote desktop connections to enabled - administrators get default access
  Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\‘ -Name “fDenyTSConnections” -Value 1 
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
  #Set network level authentication to not required (0 is disabled 1 is enabled)
  Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\‘ -Name “UserAuthentication” -Value 0 
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
  #enable the windows firewall rule
  Get-NetFirewallRule -DisplayName "Remote Desktop*" | Set-NetFirewallRule -enabled False
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