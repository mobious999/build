#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
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
    
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  https://ss64.com/ps/syntax-elevate.html
.EXAMPLE
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False,Position=1)]
  [string]$parameter1,
	
  [Parameter(Mandatory=$False)]
  [string]$parameter2,

  [Parameter(Mandatory=$False)]
  [string]$parameter3,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
)


Try {
  If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
  {
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
  }
  # Now running elevated so launch the script:
  & "d:\long path name\script name.ps1" "Long Argument 1" "Long Argument 2"   
 }
 
 Catch {
  if (!$logfolder -or $errorlog) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Add-Content $logfolder\$errorlog "The deployment failed the error message is" $ErrorMessage
    Add-Content $logfolder\$errorlog "The deployment failed the item that failed is" $FailedItem		    
  } 
	Break
 }
 
 Finally {
  if (!$logfolder -or $logfolder) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    Add-Content $logfolder\$logfile "The action completed succesfully."
    Add-Content $logfolder\$logfile "The total disk usage for this deployment is " $totaldisk
  } 
 }
