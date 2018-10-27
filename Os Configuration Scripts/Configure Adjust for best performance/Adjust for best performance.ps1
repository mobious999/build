<#
.SYNOPSIS
  This script can be used to set the setting adjust for best performance
.DESCRIPTION
  The script runs and configures the system without any parameters other than the visualfx settings which set the "adjust for best performance option"
  The available options are
  Let Windows Choose: 
  setting = 0
  Adjust for Best Appearance:
  setting = 1
  Adjust for Best Performance:
  setting = 2
.PARAMETER <Parameter_Name>
    List all parameters here
    $VisualFXSetting
    $errorlog
    $logfile
    $logfolder
.INPUTS
    List all inputs here
    $VisualFXSetting
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
  .\adjust for best performance -visualfxsetting (setting)
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$true)]
  [ValidateNotNull()]
  [int]$VisualFXSetting,
	
  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [System.IO.FileInfo]$logfolder
)

#checking inputs to make sure that there are only specific numbers
If ($VisualFXSetting -eq 0 -or $VisualFXSetting -eq 1 -or $VisualFXSetting -eq 2) {
  write-host "any 3 of the correct values are there"
}  Else {
  Write-host "you must input a value that will match the crash dump level you want see the powershell script to see the appropriate values"
  break
} 

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
  $regkey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
  Set-ItemProperty -Path $regkey -Name "VisualFXSetting" -Value $VisualFXSetting
}
 
Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
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

