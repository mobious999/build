#requires -version 2
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    Confirm
    AccountExpirationDate <DateTime>
    AccountNotDelegated <Boolean>
    AccountPassword <SecureString>
    AllowReversiblePasswordEncryption <Boolean>
    AuthenticationPolicy <ADAuthenticationPolicy>
    AuthenticationPolicySilo <ADAuthenticationPolicySilo>
    AuthType <ADAuthType>
    CannotChangePassword <Boolean>
    Certificates <X509Certificate[>
    ChangePasswordAtLogon <Boolean>
    City <String>
    Company <String>
    CompoundIdentitySupported <Boolean>
    Country <String>
    Credential <PSCredential>
    Department <String>
    Description <String>
    DisplayName <String>
    Division <String>
    EmailAddress <String>
    EmployeeID <String>
    EmployeeNumber <String>
    Enabled <Boolean>
    Fax <String>
    GivenName <String>
    HomeDirectory <String>
    HomeDrive <String>
    HomePage <String>
    HomePhone <String>
    Initials <String>
    Instance <ADUser>
    KerberosEncryptionType <ADKerberosEncryptionType>
    LogonWorkstations <String>
    Manager <ADUser>
    MobilePhone <String>
    Name <String>
    Office <String>
    OfficePhone <String>
    Organization <String>
    OtherAttributes <Hashtable>
    OtherName <String>
    PassThru
    PasswordNeverExpires <Boolean>
    PasswordNotRequired <Boolean>
    Path <String>
    POBox <String>
    PostalCode <String>
    PrincipalsAllowedToDelegateToAccount <ADPrincipal[>
    ProfilePath <String>
    SamAccountName <String>
    ScriptPath <String>
    Server <String>
    ServicePrincipalNames <String[>
    SmartcardLogonRequired <Boolean>
    State <String>
    StreetAddress <String>
    Surname <String>
    Title <String>
    TrustedForDelegation <Boolean>
    Type <String>
    UserPrincipalName <String>
.INPUTS
    List all inputs here
    Confirm
    AccountExpirationDate <DateTime>
    AccountNotDelegated <Boolean>
    AccountPassword <SecureString>
    AllowReversiblePasswordEncryption <Boolean>
    AuthenticationPolicy <ADAuthenticationPolicy>
    AuthenticationPolicySilo <ADAuthenticationPolicySilo>
    AuthType <ADAuthType>
    CannotChangePassword <Boolean>
    Certificates <X509Certificate[>
    ChangePasswordAtLogon <Boolean>
    City <String>
    Company <String>
    CompoundIdentitySupported <Boolean>
    Country <String>
    Credential <PSCredential>
    Department <String>
    Description <String>
    DisplayName <String>
    Division <String>
    EmailAddress <String>
    EmployeeID <String>
    EmployeeNumber <String>
    Enabled <Boolean>
    Fax <String>
    GivenName <String>
    HomeDirectory <String>
    HomeDrive <String>
    HomePage <String>
    HomePhone <String>
    Initials <String>
    Instance <ADUser>
    KerberosEncryptionType <ADKerberosEncryptionType>
    LogonWorkstations <String>
    Manager <ADUser>
    MobilePhone <String>
    Name <String>
    Office <String>
    OfficePhone <String>
    Organization <String>
    OtherAttributes <Hashtable>
    OtherName <String>
    PassThru
    PasswordNeverExpires <Boolean>
    PasswordNotRequired <Boolean>
    Path <String>
    POBox <String>
    PostalCode <String>
    PrincipalsAllowedToDelegateToAccount <ADPrincipal[>
    ProfilePath <String>
    SamAccountName <String>
    ScriptPath <String>
    Server <String>
    ServicePrincipalNames <String[>
    SmartcardLogonRequired <Boolean>
    State <String>
    StreetAddress <String>
    Surname <String>
    Title <String>
    TrustedForDelegation <Boolean>
    Type <String>
    UserPrincipalName <String>
.OUTPUTS
    Standard output if logs are specified    
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>

Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$parameter1,
	
  [Parameter(Mandatory=$True)]
  [string]$parameter2,

  [Parameter(Mandatory=$True)]
  [string]$parameter3,

  [Parameter(Mandatory=$false)]
  [string]$errorlog,

  [Parameter(Mandatory=$false)]
  [string]$logfile,

  [Parameter(Mandatory=$false)]
  [string]$logfolder
)

Try {
  
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
