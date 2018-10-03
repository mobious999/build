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

#Install AD DS, DNS and GPMC 
$featureLogPath = "adbuild.txt" 
start-job -Name addFeature -ScriptBlock { 
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools } 
Wait-Job -Name addFeature 
Get-WindowsFeature | Where installed >>$logfile\$logpath
Restart-Computer