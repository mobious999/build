<#
.SYNOPSIS
   This script can be used to rename a computer
.DESCRIPTION
   The script will rename the computer to whatever name is specified by the name parameter.
   
   Once renamed the script will reboot the machine.
.PARAMETER <Parameter_Name>
    List all parameters here
    $name
    $errorlog
    $logfile
    $logfolder
.INPUTS
    $name
    $errorlog
    $logfile
    $logfolder
.OUTPUTS
    Standard logfiles if enabled
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  7/29/2018
  Purpose/Change: Initial script development 
.EXAMPLE
  .\rename computer -name (name)
#>
If(Test-Path $logfolder)
  {
	    #write-host "path exists"
	}
else 
	{
		#Write-Host "path doesn't exist"
		#if the path doesn't exist create it
		New-Item -ItemType Directory -Path $logfolder
  }
Param(
    [Parameter(Mandatory=$False,Position=1)]
    [string]$name,

    [Parameter(Mandatory=$False)]
    [string]$errorlog,
  
    [Parameter(Mandatory=$False)]
    [string]$logfile,
  
    [Parameter(Mandatory=$False)]
    [string]$logfolder
)

rename local computer Computer
#$computerName = Get-WmiObject Win32_ComputerSystem
#$computername.Rename($name)
Try{
	Rename-Computer -NewName $name -Reboot
}
Catch{
    if (!$logfolder -or $errorlog) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
        Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem		    
      } 
    Break
}
Finally{
    if (!$logfolder -or $logfolder) {
        Write-Host "No logfile or log folder specified no logging will be created"
      } else {
        Add-Content $logfolder\$logfile "The action completed succesfully."
      } 
}

