<#
.SYNOPSIS
  This script can be used to perform a silent installation of sql express
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
  http://daveslog.com/2017/03/12/install-sql-express-2014-from-powershell/
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

#attempting to download sql express to c:\windows\temp
$folderpath = "c:\windows\temp"
$filepath = "$folderpath+"\SQLEXPRADV_x64_ENU.exe"
Write-host $filepath
#Download sql express advanced
write-host "Downloading SQL Server 2016 express advanced"
$URL = "https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPRADV_x64_ENU.exe"
$clnt = New-Object System.Net.WebClient
#$clnt.DownloadFile($url,$filepath)
Write-Host "Sql Express Download Complete" -ForegroundColor Green
#begin unpacking the sql install
#$folderpath\SQLEXPR_x64_ENU.exe /u /x:$folderpath

Try {
#Set-Location to where your SQL Setup.exe is located, then run:
$params = @'
/ACTION=Install /QS /FEATURES=SQL /INSTANCENAME=MSSQLSERVER /HIDECONSOLE /INDICATEPROGRESS="True" /IAcceptSQLServerLicenseTerms /SQLSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE" /SQLSYSADMINACCOUNTS="builtin\administrators" /SKIPRULES="RebootRequiredCheck" 
'@ 
  Start-process .\setup.exe $params -wait
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

Try {
#Set-Location to where your SQL Setup.exe is located, then run:
$params = @'
/ACTION=Install /QS /FEATURES=SQL /INSTANCENAME=MSSQLSERVER /HIDECONSOLE /INDICATEPROGRESS="True" /IAcceptSQLServerLicenseTerms /SQLSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE" /SQLSYSADMINACCOUNTS="builtin\administrators" /SKIPRULES="RebootRequiredCheck" 
'@ 
  Start-process .\setup.exe $params -wait
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

