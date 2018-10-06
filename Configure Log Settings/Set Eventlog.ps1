#requires -version 2
<#
.SYNOPSIS
  This script can be used to configure the windows event logs
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    Required fields (none)
.INPUTS
    Not really required but tailor them to your environment
.OUTPUTS
    
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  
.EXAMPLE
  .\set eventlog.ps1 -applicationlog (size in meg) -securitylog (size in meg) -systemlog (size in meg) -errorlog (error log name) -logfile (filename for logging) -logfolder (where you want the log to be created)
#>

Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$applicationlog,
	
  [Parameter(Mandatory=$True)]
  [string]$securitylog,

  [Parameter(Mandatory=$True)]
  [string]$systemlog,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
)

Try {
  Limit-EventLog -LogName Application -MaximumSize $applicationlog
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
    Add-Content $logfolder\$logfile "The vm has passed the diskspace check."
    Add-Content $logfolder\$logfile "The total disk usage for this deployment is $totaldisk"
    Add-Content $logfolder\$logfile "Beginning Main Deployment" 
  } 
 }

 Try {
  Limit-EventLog -LogName Security -MaximumSize $securitylog
 }
 
 Catch {
  if (!$logfile -or $errorlog) {
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
  if (!$logfile -or $logfolder) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    Add-Content $logfolder\$logfile "The vm has passed the diskspace check."
    Add-Content $logfolder\$logfile "The total disk usage for this deployment is $totaldisk"
    Add-Content $logfolder\$logfile "Beginning Main Deployment" 
  } 
 }

 Try {
  Limit-EventLog -LogName Application -MaximumSize $systemlog
 }
 
 Catch {
  if (!$logfile -or $errorlog) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Add-Content $logfolder\$errorlog "The deployment failed the error message is" $ErrorMessage
    Add-Content $logfolder\$errorlog "The deployment failed the item that failed is" $FailedItem		
  } 
 }
 
 Finally {
  if (!$logfile -or $logfolder) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    Add-Content $logfolder\$logfile "The vm has passed the diskspace check."
    Add-Content $logfolder\$logfile "The total disk usage for this deployment is $totaldisk"
    Add-Content $logfolder\$logfile "Beginning Main Deployment" 
  } 
 }