#requires -version 2
<#
.SYNOPSIS
  This script can be used to set the windows pagefile minimum and maxim to 4 gig
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    Required fields None
.INPUTS
    Not really required but tailor them to your environment
.OUTPUTS
    
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  https://support.microsoft.com/en-us/help/2860880/how-to-determine-the-appropriate-page-file-size-for-64-bit-versions-of
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

$PhysicalRAM = (Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1MB),2)})
$pagefilemin = "4096"
$pagefielmax = "4096"
Try {
  #attempt to set the pagefile to automatically being manged = off
  $getsetting = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges;
  $getsetting.AutomaticManagedPagefile = $False;
  $getsetting.Put();  
}

Catch {
 # Run this if a terminating error occurred in the Try block
 # The variable $_ represents the error that occurred
 #$_
 Add-Content $logfolder\$errorlog "There was an error when attempting set the pagefile to automatically adjust" 
 Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
 # Always run this at the end
}

Try {
  #attempt to set the pagfile minimum and maximum to 4 gig
  $pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'";
  $pagefile.InitialSize = $pagefilemin;
  $pagefile.MaximumSize = $pagefielmax;
  $pagefile.Put();
}

Catch {
 # Run this if a terminating error occurred in the Try block
 # The variable $_ represents the error that occurred
 #$_
 Add-Content $logfolder\$errorlog "There was an error when attempting set the pagefile minimum and maximum" 
 Add-content $logfolder\$errorlog "The Error is " $_
}

Finally {
  # Always run this at the end
  Write-host "Pagefile has been set"
}