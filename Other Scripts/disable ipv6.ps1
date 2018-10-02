#requires -version 2
<#
.SYNOPSIS
  This script can be used to key registry entries for any build
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    Required fields
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
  Copy the file to the host and begin the Configuration
#>

$logfolder = "c:\buildlog"
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
$errorlog = "c:\buildlog\error.log"

#disable ipv6
Try {
    New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\' -Name  'DisabledComponents' -Value '0xffffffff' -PropertyType 'DWord'
}

Catch {
 # Run this if a terminating error occurred in the Try block
 # The variable $_ represents the error that occurred
 #$_
 Add-Content $logfolder\$errorlog "There was an error when attempting disable ipv6" 
 Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
  Write-host "ipv6 has been disabled" 
}

