#requires -version 2
<#
.SYNOPSIS
   This script can be used configur snmp services
.DESCRIPTION
  This script will ip the first network card that is connected to the network
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
