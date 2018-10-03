#requires -version 2
<#
.SYNOPSIS
  This script is the first of 3 parts that build a standard domain conroller for windows
.DESCRIPTION
  Computer Name will be changed to dc01
.PARAMETER <Parameter_Name>
    Required filds
    Fqdn of the domain
    Netbios name of the domain
    Password for the ad recovery
    # other inputs (domain mode)
    Windows Server 2003: 2 or Win2003
    Windows Server 2008: 3 or Win2008
    Windows Server 2008 R2: 4 or Win2008R2
    Windows Server 2012: 5 or Win2012
    Windows Server 2012 R2: 6 or Win2012R2
    Windows Server 2016: 7 or WinThreshold

    #forestmode of the domain
    Windows Server 2003: 2 or Win2003
    Windows Server 2008: 3 or Win2008
    Windows Server 2008 R2: 4 or Win2008R2
    Windows Server 2012: 5 or Win2012
    Windows Server 2012 R2: 6 or Win2012R2
    Windows Server 2016: 7 or WinThreshold    

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

#domainmode
$domainmode = "6"
$forestmode = "6"

$logfile = "adbuild.txt"
# Create New Forest, add Domain Controller 
#static variables
$domainfull = "Quinn.local" #Fill in with the full dns suffixe
$domainnetbios = "Quinn"    #fill in with the netbios name for the domain
write-host $domainfull

$SafeModeAdministratorPasswordText = "Password123"
$SafeModeAdministratorPassword = ConvertTo-SecureString -AsPlainText $SafeModeAdministratorPasswordText -Force
Import-Module ADDSDeployment 
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainName $domainfull -DomainNetbiosName $domainnetbios -DomainMode $domainmode -ForestMode $forestmode -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $SafeModeAdministratorPassword
