<#
.SYNOPSIS
  This script can be used to set wsus options (update language and types of updates)
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
.LINK
  https://docs.microsoft.com/en-us/powershell/module/wsus/set-wsusclassification?view=win10-ps
  https://docs.microsoft.com/en-us/powershell/module/wsus/set-wsusproduct?view=win10-ps
.EXAMPLE
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [System.IO.FileInfo]$logfolder
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

Try {
  #Configure the Platforms that we want WSUS to receive updates

Get-WsusProduct | where-Object {
  $_.Product.Title -in (
  'CAPICOM',
  'Silverlight',
  'SQL Server 2008 R2',
  'SQL Server 2005',
  'SQL Server 2008',
  'Exchange Server 2010',
  'Windows Server 2003',
  'Windows Server 2008',
  'Windows Server 2008 R2')
} | Set-WsusProduct

#Configure the Classifications
Get-WsusClassification | Where-Object {
  $_.Classification.Title -in (
  'Update Rollups',
  'Security Updates',
  'Critical Updates',
  'Service Packs',
  'Updates')
} | Set-WsusClassification

  #Configure Synchronizations
  $subscription.SynchronizeAutomatically=$true
  #Set synchronization scheduled for midnight each night
  $subscription.SynchronizeAutomaticallyTimeOfDay= (New-TimeSpan -Hours 0)
  $subscription.NumberOfSynchronizationsPerDay=1
  $subscription.Save()

  #Kick off a synchronization
  $subscription.StartSynchronization()
}
 
Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
  }
    Break
}

Finally {
}

