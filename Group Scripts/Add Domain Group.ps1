#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    AuthType <ADAuthType>
    Credential <PSCredential>
    Description <String>
    DisplayName <String>
    GroupCategory <ADGroupCategory>
    GroupScope <ADGroupScope>
    HomePage <String>
    Instance <ADGroup>
    ManagedBy <ADPrincipal>
    Name <String>
    OtherAttributes <Hashtable>
    PassThru
    Path <String>
    SamAccountName <String>
    Server <String>
    $errorlog
    $logfile
    $logfolder
.INPUTS
    List all inputs here
    AuthType <ADAuthType>
      Negotiate or 0
      Basic or 1
    Credential <PSCredential>
    Description <String>
    DisplayName <String>
    GroupCategory <ADGroupCategory>
      Distribution or 0
      Security or 1
    GroupScope <ADGroupScope>
      DomainLocal or 0
      Global or 1
      Universal or 2
    HomePage <String>
    Instance <ADGroup>
    ManagedBy <ADPrincipal>
      A distinguished name
      A GUID (objectGUID)
      A security identifier (objectSid)
      SAM account name (sAMAccountName)
    Name <String>
    OtherAttributes <Hashtable>
      To specify a single value for an attribute:
      -OtherAttributes @{'AttributeLDAPDisplayName'=value}
      To specify multiple values for an attribute
      -OtherAttributes @{'AttributeLDAPDisplayName'=value1,value2,...}
    PassThru
    Path <String>
    SamAccountName <String>
    Server <String>
    Domain name values:
      Fully qualified domain name
      NetBIOS name
      Directory server values:

      Fully qualified directory server name
      NetBIOS name
      Fully qualified directory server name and port
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created

.OUTPUTS
    Logging Where required see below for how to enable    
.NOTES
    Version:        1.0
    Author:         Mark Quinn
    Creation Date:  9/30/2018
    Purpose/Change: Initial script development
    Based on this article
    https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-adgroup?view=win10-ps
.EXAMPLE
  Example 1: Create a group and set its properties
  New-ADGroup -Name "RODC Admins" -SamAccountName RODCAdmins -GroupCategory Security -GroupScope Global -DisplayName "RODC Administrators" -Path "CN=Users,DC=Fabrikam,DC=Com" -Description "Members of this group are RODC Administrators"
  Example 2: Create a group using existing property values
  Get-ADGroup FabrikamBranch1 -Properties Description | New-ADGroup -Name "Branch1Employees" -SamAccountName "Branch1Employees" -GroupCategory Distribution -PassThru 
  Example 3: Create a group on an LDS instance
  New-ADGroup -Server localhost:60000 -Path "OU=AccountDeptOU,DC=AppNC" -Name "AccountLeads" -GroupScope DomainLocal -GroupCategory Distribution
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False,Position=1)]
  [string]$parameter1,
  [Parameter(Mandatory=$False)]
  [string]$AuthType,
  [Parameter(Mandatory=$False)]
  [SecureString]$Credential,
  [Parameter(Mandatory=$False)]
  [string]$Description,
  [Parameter(Mandatory=$False)]
  [string]$DisplayName,
  [Parameter(Mandatory=$False)]
  [string]$GroupCategory,
  [Parameter(Mandatory=$False)]
  [string]$GroupScope,
  [Parameter(Mandatory=$True)]
  [string]$HomePage,
  [Parameter(Mandatory=$False)]
  [string]$Instance,
  [Parameter(Mandatory=$False)]
  [string]$ManagedBy,
  [Parameter(Mandatory=$True)]
  [string]$Name,
  [Parameter(Mandatory=$False)]
  [string]$OtherAttributes,
  [Parameter(Mandatory=$False)]
  [string]$PassThru,
  [Parameter(Mandatory=$False)]
  [string]$Path,
  [Parameter(Mandatory=$False)]
  [string]$SamAccountName,
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
  New-ADGroup -Name $name -SamAccountName $SamAccountName -GroupCategory $groupcategory -GroupScope $groupscope -DisplayName $DisplayName -Path $path -Description $Description
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
    Add-Content $logfolder\$logfile "The action completed succesfully."
    Add-Content $logfolder\$logfile "The total disk usage for this deployment is " $totaldisk
  } 
 }
