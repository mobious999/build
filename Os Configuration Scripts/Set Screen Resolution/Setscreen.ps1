#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to Set the screen resolution
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    $width
    $height
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
  .\Setscreen.ps1 -width 1024 -height 768
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [int]$width,
	
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [int]$height,

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
  Set-DisplayResolution -Width $width -Height $height -Force
}
 
Catch {
  $error = $_.Exception 
  $ErrorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $Error
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $Error
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $error
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
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

