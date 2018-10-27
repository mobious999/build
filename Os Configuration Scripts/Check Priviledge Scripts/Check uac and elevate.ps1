<#
.SYNOPSIS
  This script can be used to check and elevate the users uac permissions automatically.

.DESCRIPTION
  The script can be used to check the uac elevation status and then elevate the user permissions to administrator level.

  This script can be used for example only to demonstrate how to elevate there are no parameters or actions carried out.

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
  None

.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development

.EXAMPLE
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
  
.LINK
  Based on this article
  https://ss64.com/ps/syntax-elevate.html
#>

Param(
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
  } 
 }
