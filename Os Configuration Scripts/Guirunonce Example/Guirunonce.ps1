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
  
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>
#Reference Registry Keys for Run
#HKEYLOCALMACHINE\Software\Microsoft\Windows\CurrentVersion\Run
#HKEYCURRENTUSER\Software\Microsoft\Windows\CurrentVersion\Run
#Reference Registry Keys for Run once
#HKEYLOCALMACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce
#HKEYCURRENTUSER\Software\Microsoft\Windows\CurrentVersion\RunOnce
#Example script form https://cmatskas.com/configure-a-runonce-task-on-windows/
#Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name '!RegisterDNS' -Value "c:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command 'Register-DnsClient'"  