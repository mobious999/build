#requires -version 2
<#
.SYNOPSIS
  This script can be used to add a local user account
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    See the example below
    $name
    $password
    $Accountexpires
    $Accountneverexpires
    $confirm
    $description
    $disabled
    $fullname
    $passwordneverexpires
    $usermaynotchangepassword
    $errorlog
    $logfile
    $logfolder
.INPUTS
    See the example below
    $name
    $password
    $Accountexpires
    $Accountneverexpires
    $confirm
    $description
    $disabled
    $fullname
    $passwordneverexpires
    $usermaynotchangepassword
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created
.OUTPUTS
    Loggiing where needed
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/new-localuser?view=powershell-5.1
.EXAMPLE
  Create a user account
  New-LocalUser -Name "User02" -Description "Description of this account." -NoPassword
  Create a user account that has a password
  New-LocalUser "User03" -Password $Password -FullName "Third User" -Description "Description of this account."
  .\add local user -name (name) -password (password) -Accountexpires (date) -confirm $false -description (description of the user) -disabled (true / false) -fullname "name of user" -passwordneverexpires (true/false) -$UserMayNotChangePassword (true/false) -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$name,
	
  [Parameter(Mandatory=$False)]
  [Securestring]$Password,

  [Parameter(Mandatory=$False)]
  [string]$AccountExpires,

  [Parameter(Mandatory=$False)]
  [string]$AccountNeverExpires,

  [Parameter(Mandatory=$False)]
  [string]$Confirm,

  [Parameter(Mandatory=$False)]
  [string]$Description,

  [Parameter(Mandatory=$False)]
  [string]$Disabled,

  [Parameter(Mandatory=$False)]
  [string]$FullName,

  [Parameter(Mandatory=$False)]
  [Securestring]$PasswordNeverExpires,

  [Parameter(Mandatory=$False)]
  [Securestring]$UserMayNotChangePassword,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
)

Try {
  New-LocalUser $name -Password $Password -FullName $fullname -Description $description 
 }
 
Catch {
	$ErrorMessage = $_.Exception.Message
	$FailedItem = $_.Exception.ItemName
	Add-Content $logfolder\$errorlog "The user has not been created the error message is" $ErrorMessage
	Add-Content $logfolder\$errorlog "The the item that failed is" $FailedItem		
	Break
}
 
 Finally {
    Add-Content $logfolder\$logfile "The user has been created succesfully."
}