#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    Confirm
    AuthType <ADAuthType>
    Credential <PSCredential>
    Identity <ADGroup>
    Members <ADPrincipal[>
    MemberTimeToLive <TimeSpan>
    Partition <String>
    PassThru
    Server <String>
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created
.INPUTS
    List all inputs here
    $Confirm
    $AuthType <ADAuthType>
    $Credential <PSCredential>
    $Identity <ADGroup>
    $Members <ADPrincipal[>
    $MemberTimeToLive <TimeSpan>
    $Partition <String>
    $PassThru
    $Server <String>
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created
.OUTPUTS
    Logging where required just add the log variables
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  https://docs.microsoft.com/en-us/powershell/module/addsadministration/add-adgroupmember?view=win10-ps
.EXAMPLE
  Copy the file to the host and begin the Configuration
  Example 1: Add specified user accounts to a group
  Add-ADGroupMember -Identity SvcAccPSOGroup -Members SQL01,SQL02
  Example 2: Add all user accounts to a group
  Add-ADGroupMember
  cmdlet Add-ADGroupMember at command pipeline position 1
  Supply values for the following parameters: 
  Identity: RodcAdmins
  Members[0]: DavidChew
  Members[1]: PattiFuller
  Members[2]:
  Example 3: Add an account by distinguished name to a filtered group
  Get-ADGroup -Server localhost:60000 -SearchBase "OU=AccountDeptOU,DC=AppNC" -Filter { name -like "AccountLeads" } | Add-ADGroupMember -Members "CN=PattiFuller,OU=AccountDeptOU,DC=AppNC"
  Example 4: Add a user from a domain to a group in another domain
  $User = Get-ADUser -Identity "CN=Chew David,OU=UserAccounts,DC=NORTHAMERICA,DC=FABRIKAM,DC=COM" -Server "northamerica.fabrikam.com"
  $Group = Get-ADGroup -Identity "CN=AccountLeads,OU=UserAccounts,DC=EUROPE,DC=FABRIKAM,DC=COM" -Server "europe.fabrikam.com"
  Add-ADGroupMember -Identity $Group -Members $User -Server "europe.fabrikam.com"
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False,Position=1)]
  [string]$AuthType,
  [Parameter(Mandatory=$False)]
  [SecureString]$Credential,
  [Parameter(Mandatory=$False)]
  [string]$Identity,
  [Parameter(Mandatory=$False)]
  [string]$Members,
  [Parameter(Mandatory=$False)]
  [string]$MemberTimeToLive,
  [Parameter(Mandatory=$False)]
  [string]$Partition,
  [Parameter(Mandatory=$False)]
  [string]$PassThru,
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
  Add-ADGroupMember -Identity SvcAccPSOGroup -Members SQL01,SQL02
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
