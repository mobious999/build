<#
.SYNOPSIS
  This script will install any msi application with logs
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    Required fields
.INPUTS
    Filename to install
.OUTPUTS
    All logging in the execution directory with verbose switch
.NOTES
  Version:        1.0
  Author:         
  Creation Date:  9/30/2018
  Purpose/Change: sample script from https://kevinmarquette.github.io/2016-10-21-powershell-installing-msi-files/
  
.EXAMPLE
  Copy the files to the host and begin the Configuration
  
#>
$file = "msi filename"
$DataStamp = get-date -Format yyyyMMddTHHmmss
$logFile = '{0}-{1}.log' -f $file.fullname,$DataStamp
$MSIArguments = @(
    "/i"
    ('"{0}"' -f $file.fullname)
    "/qn"
    "/norestart"
    "/L*v"
    $logFile
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 