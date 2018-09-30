#requires -version 2
<#
.SYNOPSIS
  This script can be used to add guirunonce scripts
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
  https://support.microsoft.com/en-us/help/2860880/how-to-determine-the-appropriate-page-file-size-for-64-bit-versions-of
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>
$PhysicalRAM = (Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1MB),2)})
$pagefilemin = "4096"
$pagefielmax = "4096"

$getsetting = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges;
$getsetting.AutomaticManagedPagefile = $False;
$getsetting.Put();
$pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'";
$pagefile.InitialSize = $pagefilemin;
$pagefile.MaximumSize = $pagefielmax;
$pagefile.Put();