<#
.SYNOPSIS
   This script can be used add the desktop experiece to a windows host
.DESCRIPTION
  The script just adds the feature without any interaction
.PARAMETER <Parameter_Name>
    Required fields none
.INPUTS
    See above
.OUTPUTS
    None
.NOTES
  Version:        1.0
  Author:         Spiceworks
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
.LINK
  This script is based on this article
  https://community.spiceworks.com/topic/389336-script-to-install-snmp-and-change-community-name
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>
#Import ServerManger Module
Import-Module ServerManager

#Check If Backup features Are Already Installed
$check = Get-WindowsFeature | Where-Object {$_.Name -eq "Desktop-Experience"}
If ($check.Installed -ne "True") {
	Add-WindowsFeature Desktop-Experience | Out-Null
}
