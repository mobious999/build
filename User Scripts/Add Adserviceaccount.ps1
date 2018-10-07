#requires -version 5
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    $errorlog
    $logfile
    $logfolder
    WhatIf
    $Confirm
    $AccountExpirationDate <DateTime>
    $AccountNotDelegated <Boolean>
    $AuthenticationPolicy <ADAuthenticationPolicy>
    $AuthenticationPolicySilo <ADAuthenticationPolicySilo>
    $AuthType <ADAuthType>
    $Certificates <String
    $CompoundIdentitySupported <Boolean>
    $Credential <PSCredential>
    $Description <String>
    $DisplayName <String>
      -DNSHostName <String>
    $Enabled <Boolean>
    $HomePage <String>
    $Instance <ADServiceAccount>
    $KerberosEncryptionType <ADKerberosEncryptionType>
    $ManagedPasswordIntervalInDays <Int32>
    $Name <String>
    $OtherAttributes <Hashtable>
    $PassThru
    $Path <String>
    $PrincipalsAllowedToDelegateToAccount <ADPrincipal
    $PrincipalsAllowedToRetrieveManagedPassword <ADPrincipal
    $SamAccountName <String>
    $Server <String>
    $ServicePrincipalNames <String
    $TrustedForDelegation <Boolean>
    #required parameters
    -DNSHostName
    -Name
    -RestrictToOutboundAuthenticationOnly
    -RestrictToSingleComputer
.INPUTS
    List all inputs here
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created
    $Confirm
    $AccountExpirationDate <DateTime>
    $AccountNotDelegated <Boolean>
    $AuthenticationPolicy <ADAuthenticationPolicy>
    $AuthenticationPolicySilo <ADAuthenticationPolicySilo>
    $AuthType <ADAuthType>
    $Certificates <String
    $CompoundIdentitySupported <Boolean>
    $Credential <PSCredential>
    $Description <String>
    $DisplayName <String>
      -DNSHostName <String>
    $Enabled <Boolean>
    $HomePage <String>
    $Instance <ADServiceAccount>
    $KerberosEncryptionType <ADKerberosEncryptionType>
    $ManagedPasswordIntervalInDays <Int32>
    $Name <String>
    $OtherAttributes <Hashtable>
    $PassThru
    $Path <String>
    $PrincipalsAllowedToDelegateToAccount <ADPrincipal
    $PrincipalsAllowedToRetrieveManagedPassword <ADPrincipal
    $SamAccountName <String>
    $Server <String>
    $ServicePrincipalNames <String
    $TrustedForDelegation <Boolean>
.OUTPUTS
    Standard logging is available when using the $errorlog $logfile and $logdir directories    
.NOTES
    Version:        1.0
    Author:         Mark Quinn
    Creation Date:  9/30/2018
    Purpose/Change: Initial script development
    Based on this article
    https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-adserviceaccount?view=win10-ps
.EXAMPLE
    #Create an enabled managed service account
    New-ADServiceAccount -Name "Service01" -DNSHostName "Service01.contoso.com" -Enabled $True -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
    #Create a managed service account and register its service principal name
    New-ADServiceAccount -Name "Service01" -ServicePrincipalNames "MSSQLSVC/Machine3.corp.contoso.com" -DNSHostName "Service01.contoso.com" -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
    #Create a managed service account for a single computer
    New-ADServiceAccount -Name "Service01" -RestrictToSingleComputer -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
    #Create a managed service account for outbound authentication only
    New-ADServiceAccount -Name "Service01" -RestrictToOutboundAuthenticationOnly -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False,Position=1)]
  [string]$Confirm,
  [Parameter(Mandatory=$False)]
  [string]$AccountExpirationDate,
  [Parameter(Mandatory=$False)]
  [string]$AccountNotDelegated,
  [Parameter(Mandatory=$False)]
  [string]$AuthenticationPolicy,
  [Parameter(Mandatory=$False)]
  [string]$AuthenticationPolicySilo,
  [Parameter(Mandatory=$False)]
  [string]$AuthType,
  [Parameter(Mandatory=$False)]
  [string]$Certificates,
  [Parameter(Mandatory=$False)]
  [string]$CompoundIdentitySupported,
  [Parameter(Mandatory=$False)]
  [SecureString]$Credential,
  [Parameter(Mandatory=$False)]
  [string]$Description,
  [Parameter(Mandatory=$False)]
  [string]$Displayname,
  [Parameter(Mandatory=$True)]
  [string]$DNSHostName,
  [Parameter(Mandatory=$True)]
  [string]$Enabled,
  [Parameter(Mandatory=$False)]
  [string]$HomePage,
  [Parameter(Mandatory=$False)]
  [string]$Instance,
  [Parameter(Mandatory=$False)]
  [string]$KerberosEncryptionType,
  [Parameter(Mandatory=$False)]
  [SecureString]$ManagedPasswordIntervalInDay,
  [Parameter(Mandatory=$True)]
  [string]$Name,
  [Parameter(Mandatory=$False)]
  [string]$OtherAttributes,
  [Parameter(Mandatory=$False)]
  [string]$PassThru,
  [Parameter(Mandatory=$False)]
  [string]$Path,
  [Parameter(Mandatory=$False)]
  [string]$PrincipalsAllowedToDelegateToAccount,
  [Parameter(Mandatory=$False)]
  [SecureString]$PrincipalsAllowedToRetrieveManagedPassword,
  [Parameter(Mandatory=$False)]
  [SecureString]$RestrictToSingleComputer,
  [Parameter(Mandatory=$False)]
  [SecureString]$RestrictToOutboundAuthenticationOnly,
  [Parameter(Mandatory=$False)]
  [string]$SamAccountName,
  [Parameter(Mandatory=$False)]
  [string]$Server,
  [Parameter(Mandatory=$False)]
  [string]$ServicePrincipalNames,
  [Parameter(Mandatory=$False)]
  [string]$TrustedForDelegation,
  [Parameter(Mandatory=$False)]
  [string]$errorlog,
  [Parameter(Mandatory=$False)]
  [string]$logfile,
  [Parameter(Mandatory=$False)]
  [string]$logfolder
)

Try {
  New-ADServiceAccount -Name $name -DNSHostName $DNSHostName -Enabled $Enabled
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
