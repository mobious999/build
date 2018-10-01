#requires -version 2
<#
.SYNOPSIS
   This script can be used configur snmp services
.DESCRIPTION
  This script will ip the first network card that is connected to the network
.PARAMETER <Parameter_Name>
    Required fields 
	Snmp managers
	Snmp community string for the configuration
.INPUTS
    See above
.OUTPUTS
    all errors go to c:\buildlog
    an error log will be generated if there are errors.   
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
#Powershell Script To Install SNMP Services (SNMP Service, SNMP WMI Provider)
#Variables :)
$pmanagers = "ADD YOUR MANAGER(s)"
$commstring = "ADD YOUR COMM STRING"

#Import ServerManger Module
Import-Module ServerManager

#Check If SNMP Services Are Already Installed
$check = Get-WindowsFeature | Where-Object {$_.Name -eq "SNMP-Services"}
If ($check.Installed -ne "True") {
	#Install/Enable SNMP Services
	Add-WindowsFeature SNMP-Service | Out-Null
}

##Verify Windows Servcies Are Enabled
If ($check.Installed -eq "True"){
	#Set SNMP Permitted Manager(s) ** WARNING : This will over write current settings **
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v 1 /t REG_SZ /d localhost /f | Out-Null
	#Used as counter for incremting permitted managers
	$i = 2
	Foreach ($manager in $pmanagers){
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v $i /t REG_SZ /d $manager /f | Out-Null
		$i++
		}
	#Set SNMP Community String(s)- *Read Only*
	Foreach ( $string in $commstring){
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v $string /t REG_DWORD /d 4 /f | Out-Null
		}
}
Else {Write-Host "Error: SNMP Services Not Installed"}