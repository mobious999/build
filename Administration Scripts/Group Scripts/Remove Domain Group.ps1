#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    AuthType <ADAuthType>
    Credential <PSCredential>
    Identity <ADGroup>
    Partition <String>
    Server <String>
    $errorlog
    $logfile
    $logfolder
.INPUTS
    List all inputs here
    AuthType <ADAuthType>
      Negotiate or 0
      Basic or 1
    Credential <PSCredential>
    Identity <ADGroup>
    Partition <String>
    Server <String>
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created
.OUTPUTS
    Logging where requried for testing
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  
.EXAMPLE
  Example 1: Remove a group by name
  Remove-ADGroup -Identity SanjaysReports
  Example 2: Get filtered groups and remove them
  Get-ADGroup -Filter 'Name -like "Sanjay*"' | Remove-ADGroup
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
  [Parameter(Mandatory=$False,Position=1)]
  [string]$AuthType,
  [Parameter(Mandatory=$False)]
  [SecureString]$Credential,
  [Parameter(Mandatory=$true)]
  [string]$Identity,
  [Parameter(Mandatory=$False)]
  [string]$Partition,
  [Parameter(Mandatory=$False)]
  [string]$Server,
  [Parameter(Mandatory=$False)]
  [string]$errorlog,
  [Parameter(Mandatory=$False)]
  [string]$logfile,
  [Parameter(Mandatory=$False)]
  [string]$logfolder
)

Try {
  Remove-ADGroup -Identity $Identity -confirm $False
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
