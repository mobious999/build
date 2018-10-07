#requires -version 5
<#
.SYNOPSIS
    This script can be used to remove an active directory user
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    $AuthType <ADAuthType>
    $Credential <PSCredential>
    $Identity <ADUser>
    $name (name of user)
    $Partition <String>
    $Server <String>
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created

.INPUTS
    List all inputs here
    $AuthType <ADAuthType>
    $Credential <PSCredential>
    $Identity <ADUser>
    $name (name of user)
    $Partition <String>
    $Server <String>
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created

.OUTPUTS
    Logging where required    
.NOTES
    Version:        1.0
    Author:         Mark Quinn
    Creation Date:  9/30/2018
    Purpose/Change: Initial script development
    Based on this article
    https://docs.microsoft.com/en-us/powershell/module/addsadministration/remove-aduser?view=win10-ps
.EXAMPLE
    Remove a specified user
    Remove-ADUser -Identity GlenJohn
    Remove a filtered list of users
    Search-ADAccount -AccountDisabled | where {$_.ObjectClass -eq 'user'} | Remove-ADUser
    Remove a user by distinguished name
    Remove-ADUser -Identity "CN=Glen John,OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"
#>

Param(
  [Parameter(Mandatory=$False,Position=1)]
  [string]$AuthType,
  [Parameter(Mandatory=$False)]
  [SecureString]$Credential,
  [Parameter(Mandatory=$true)]
  [string]$Identity,
  [Parameter(Mandatory=$False)]
  [string]$Partition,
  [Parameter(Mandatory=$False)]
  [string]$Server,
  [Parameter(Mandatory=$False)]
  [string]$errorlog,
  [Parameter(Mandatory=$False)]
  [string]$logfile,
  [Parameter(Mandatory=$False)]
  [string]$logfolder
)


Try {
  Remove-ADUser -Identity $Identity
 }
 
 Catch {
  if (!$logfolder -or $errorlog) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Add-Content $logfolder\$errorlog "The deployment failed the error message is" $ErrorMessage
    Add-Content $logfolder\$errorlog "The deployment failed the item that failed is" $FailedItem		    
  } 
	Break
 }
 
 Finally {
  if (!$logfolder -or $logfolder) {
    Write-Host "No logfile or log folder specified no logging will be created"
  } else {
    Add-Content $logfolder\$logfile "The vm has passed the diskspace check."
    Add-Content $logfolder\$logfile "The total disk usage for this deployment is $totaldisk"
    Add-Content $logfolder\$logfile "Beginning Main Deployment" 
  } 
 }
