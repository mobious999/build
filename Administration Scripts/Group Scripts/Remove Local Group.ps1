#requires -version 2
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    $name
    $errorlog
    $logfile
    $logpath
.INPUTS
    List all inputs here
    $name
    $errorlog
    $logfile
    $logpath
.OUTPUTS
    Standard logs    
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  
.EXAMPLE
  Example 1: Delete a security group
  Remove-LocalGroup -Name "SecurityGroup04"
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
  [string]$name,
	
  [Parameter(Mandatory=$True)]
  [string]$errorlog,

  [Parameter(Mandatory=$True)]
  [string]$logfile,

  [Parameter(Mandatory=$True)]
  [string]$logfolder
)


Try {
  Remove-LocalGroup -Name $name
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
