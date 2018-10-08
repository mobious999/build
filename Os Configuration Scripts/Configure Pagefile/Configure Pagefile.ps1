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
  .\configure pagefile -pagefilemin (size in meg) -pagefilemax (size in meg)
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
  Param(
    [Parameter(Mandatory=$False,Position=1)]
    [string]$pagefilemin,
    
    [Parameter(Mandatory=$False)]
    [string]$pagefielmax,
   
    [Parameter(Mandatory=$False)]
    [string]$errorlog,
  
    [Parameter(Mandatory=$False)]
    [string]$logfile,
  
    [Parameter(Mandatory=$False)]
    [string]$logfolder
  )

#$PhysicalRAM = (Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1MB),2)})

Try {
  #attempt to set the pagefile to automatically being manged = off
  $getsetting = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges;
  $getsetting.AutomaticManagedPagefile = $False;
  $getsetting.Put();  
}

Catch {
  if (!$logfolder -or $errorlog) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Add-Content $logfolder\$errorlog "The Error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
  } 
  Break 
}

Finally {
  Add-Content $logfolder\$logfile "The action completed succesfully."
}

Try {
  #attempt to set the pagfile minimum and maximum to 4 gig
  $pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'";
  $pagefile.InitialSize = $pagefilemin;
  $pagefile.MaximumSize = $pagefielmax;
  $pagefile.Put();
}

Catch {
  if (!$logfolder -or $errorlog) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Add-Content $logfolder\$errorlog "The Error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
  } 
  Break 
}

Finally {
  # Always run this at the end
  Add-Content $logfolder\$logfile "The action completed succesfully."
  Write-host "Pagefile has been set"
}