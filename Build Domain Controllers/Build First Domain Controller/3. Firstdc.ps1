<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    Domainfqdn (Fqdn of the domain)
    Domainnetbios (Netbios name of the domain)
    Password for the ad recovery
    # other inputs (domain mode)
    Windows Server 2003: 2 or Win2003
    Windows Server 2008: 3 or Win2008
    Windows Server 2008 R2: 4 or Win2008R2
    Windows Server 2012: 5 or Win2012
    Windows Server 2012 R2: 6 or Win2012R2
    Windows Server 2016: 7 or WinThreshold

    #forestmode of the (Forest mode)
    Windows Server 2003: 2 or Win2003
    Windows Server 2008: 3 or Win2008
    Windows Server 2008 R2: 4 or Win2008R2
    Windows Server 2012: 5 or Win2012
    Windows Server 2012 R2: 6 or Win2012R2
    Windows Server 2016: 7 or WinThreshold    
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
  https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=win10-ps
.EXAMPLE
  .\3.Firstdc -domainmode () -forestmode () -domainfqdn () -domainnetbios () -password ()
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [string]$domainmode,
	
  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [string]$forestmode,

  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [string]$domainfqdn,

  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [string]$domainnetbios,

  [Parameter(Mandatory=$True)]
  [ValidateNotNull()]
  [Security.SecureString]$password,
  
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
  Import-Module ADDSDeployment 
  Install-ADDSForest -CreateDnsDelegation:$True -DatabasePath "C:\Windows\NTDS" -DomainName $domainfqdn -DomainNetbiosName $domainnetbios -DomainMode $domainmode -ForestMode $forestmode -InstallDns:$true -LogPath $LogPath\$logfile -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $password
}
 
Catch {
  $myerror = $_.Exception 
  $ErrorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myerror
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myerror
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
Restart-Computer