#requires -version 2
<#
.SYNOPSIS
   This script can be used to rename a computer
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    Required fields
	Name of the computer to rename
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
  Copy the file to the host and begin the Configuration 
#>

rename local computer Computer
$computerName = Get-WmiObject Win32_ComputerSystem
$computername.Rename($name)
Try{
	Write-host "attempting to rename the computer"
	#Rename-Computer -NewName PC04 -Reboot
}
Catch{

}
Finally{
	write-host "computer has been renamed"
}

