#requires -version 2
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    Group
    Member
    Name
    SID
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created
.INPUTS
    List all inputs here
    Group
    Member
    Name
    SID
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created

.OUTPUTS
    Logging where required see the below parameter line to add to a command
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  
.EXAMPLE
  Example 1: Add members to the Administrators group
  Add-LocalGroupMember -Group "Administrators" -Member "Admin02", "MicrosoftAccount\username@Outlook.com", "AzureAD\DavidChew@contoso.com", "CONTOSO\Domain Admins"
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
  [Parameter(Mandatory=$True,Position=1)]
  [string]$Group,

  [Parameter(Mandatory=$False)]
  [string]$Member,
  [Parameter(Mandatory=$False)]
  [string]$Name,
  [Parameter(Mandatory=$False)]
  [string]$SID,
  [Parameter(Mandatory=$False)]
  [string]$errorlog,
  [Parameter(Mandatory=$False)]
  [string]$logfile,
  [Parameter(Mandatory=$False)]
  [string]$logfolder
)


Try {
  Add-LocalGroupMember -Group $group -Member $member
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
