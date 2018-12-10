<#
.SYNOPSIS
  This script can be used to adjust tcp offload settings per vendor reccomendations

.DESCRIPTION
  There are several performance issues that can be resolved by adjusting the offload / rss settings
  
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

.EXAMPLE
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
.LINK
  http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.vsphere.networking.doc/GUID-D80AEC2F-E0DA-4172-BFFD-B721BF36C2E8.html
  https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2008925
  https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2129176
  https://blogs.technet.microsoft.com/networking/2016/08/11/an-update-on-windows-tcp-autotuninglevel/
  https://answers.microsoft.com/en-us/windows/forum/windows_10-hardware/windows-10-large-file-transfer-speed-drop/ba6dd310-f025-4577-8247-8afd9a081876
  https://support.citrix.com/article/CTX117491
  https://support.microsoft.com/en-us/help/904946/you-experience-intermittent-communication-failure-between-computers-th
  https://support.citrix.com/article/CTX117491
  https://kb.vmware.com/s/article/2055853
#>

Param(
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$parameter1,
	
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$parameter2,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$parameter3,

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
    Write-host "The item that failed is " $faileditem
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

