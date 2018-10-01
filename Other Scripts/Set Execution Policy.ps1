#requires -version 2
<#
.SYNOPSIS
  This script can be used set the powershell ExecutionPolicy
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
$Policy = "RemoteSigned"

Try {
    If ((get-ExecutionPolicy) -ne $Policy) {
        Set-ExecutionPolicy $Policy -Force
        #Exit
    }
}

Catch {
    # Run this if a terminating error occurred in the Try block
    # The variable $_ represents the error that occurred
    #$_
    Add-Content $logfolder\$errorlog "There was an error when attempting to set the execution policy" 
    Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
 # Always run this at the end
 write-host "Powershell Execution policy has been set correctly to Remotesigned"
}


If ((get-ExecutionPolicy) -ne $Policy) {
  Set-ExecutionPolicy $Policy -Force
  Exit
}
