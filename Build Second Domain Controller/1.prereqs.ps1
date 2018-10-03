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
#set the powershell execution policy to remote signed

$Policy = "RemoteSigned"
If ((get-ExecutionPolicy) -ne $Policy) {
  Set-ExecutionPolicy $Policy -Force
  Exit
}

#disable ipv6
New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\' -Name  'DisabledComponents' -Value '0xffffffff' -PropertyType 'DWord'

#install features 
$LogPath = "c:\adbuild" 
If(Test-Path $LogPath)
  	{
	    #write-host "path exists"
	}
else 
	{
		#Write-Host "path doesn't exist"
		#if the path doesn't exist create it
		New-Item -ItemType Directory -Path $LogPath
	}

#build the first domain controller
#static ip information first
$ipaddress = "x.x.x.x" 
#this number below is in cidr notation in this case 255.255.255.0
$ipprefix = "24" 
$ipgw = "x.x.x.x" 
$ipdns = "x.x.x.x" 
$ipif = (Get-NetAdapter).ifIndex 
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif -DefaultGateway $ipgw

#rename the computer
$newname = "dc02" 
Rename-Computer -NewName $newname –force

#install features 
$logfile = "adbuild.txt" 
New-Item $featureLogPath -ItemType file -Force 
$addsTools = "RSAT-AD-Tools" 
Add-WindowsFeature $addsTools 
Get-WindowsFeature | Where-Object installed >>$logpath\logfile
Restart-Computer
