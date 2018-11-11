<#
.SYNOPSIS
  This script can be used to configure wsus options
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    AllUpdateLanguagesEnabled (true / false)
    SetEnabledUpdateLanguages (en)
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
 https://blogs.technet.microsoft.com/heyscriptingguy/2013/04/15/installing-wsus-on-windows-server-2012/
 https://docs.microsoft.com/en-us/powershell/module/wsus/set-wsusserversynchronization?view=win10-ps
.EXAMPLE
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$AllUpdateLanguagesEnabled,
	
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$SetEnabledUpdateLanguages,

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
  #Get WSUS Server Object
  $wsus = Get-WSUSServer
  #Connect to WSUS server configuration
  $wsusConfig = $wsus.GetConfiguration()
  #Set to download updates from Microsoft Updates
  Set-WsusServerSynchronization –SyncFromMU
  #Set Update Languages to English and save configuration settings
  $wsusConfig.AllUpdateLanguagesEnabled = $false           
  $wsusConfig.SetEnabledUpdateLanguages("en")           
  $wsusConfig.Save()
  #Get WSUS Subscription and perform initial synchronization to get latest categories
  $subscription = $wsus.GetSubscription()
  $subscription.StartSynchronizationForCategoryOnly()
  While ($subscription.GetSynchronizationStatus() -ne 'NotProcessing') {
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 5
}
    Write-Host "Sync is done." 
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
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}

