#requires -version 2
<#
.SYNOPSIS
  This script is the first of 3 parts that build a standard domain conroller for windows
.DESCRIPTION
  Computer Name will be changed to dc01
.PARAMETER <Parameter_Name>
    Required filds
	ip address informatin
	Computer name
.INPUTS
    Not really required but tailor them to your environment
.OUTPUTS
  All logging goes to c:\adbuild.txt
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  7/29/2018
  Purpose/Change: Initial script development
  
.EXAMPLE
  Copy the file to the host and begin the configuraton
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
$Policy = "RemoteSigned"
If ((get-ExecutionPolicy) -ne $Policy) {
  Set-ExecutionPolicy $Policy -Force
  Exit
}

#build the first domain controller
#static ip information first
$ipaddress = "192.168.136.150" 
$ipprefix = "24" 
$ipgw = "192.168.136.2" 
$ipdns = "192.168.136.150" 
$ipif = (Get-NetAdapter).ifIndex 
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif -DefaultGateway $ipgw

#rename the computer
$newname = "dc01" 
Rename-Computer -NewName $newname –force

#install features 
$featureLogPath = "c:\adbuild.txt" 
New-Item $featureLogPath -ItemType file -Force 
$addsTools = "RSAT-AD-Tools" 
Add-WindowsFeature $addsTools 
Get-WindowsFeature | Where installed >>$featureLogPath
Restart-Computer
