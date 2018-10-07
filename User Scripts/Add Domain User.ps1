#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to (insert what it does here)
.DESCRIPTION
  This script can be used to create ad users with all parameters if required also with error logging
.PARAMETER <Parameter_Name>
    List all parameters here
    Name
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
    Name
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
  https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-aduser?view=win10-ps
.EXAMPLE
  Create a user with an imported certificate
  New-ADUser -Name "ChewDavid" -Certificate (New-Object System.Security.Cryptography.X509Certificates.X509Certificate -ArgumentList "Export.cer")
  Create a user and set properties
  New-ADUser -Name "ChewDavid" -OtherAttributes @{'title'="director";'mail'="chewdavid@fabrikam.com"}
  Create an inetOrgPerson user
  New-ADUser -Name "ChewDavid" -Type iNetOrgPerson -Path "DC=AppNC" -Server lds.Fabrikam.com:50000
  New-Aduser -name $name -$accountpassword $accountpassword -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$name,
  [Parameter(Mandatory=$False)]
  [string]$Confirm,
  [Parameter(Mandatory=$False)]
  [string]$AccountExpirationDate,
  [Parameter(Mandatory=$False)]
  [string]$AccountNotDelegated,
  [Parameter(Mandatory=$True)]
  [securestring]$AccountPassword,
  [Parameter(Mandatory=$False)]
  [securestring]$AllowReversiblePasswordEncryption,
  [Parameter(Mandatory=$False)]
  [string]$AuthenticationPolicy,
  [Parameter(Mandatory=$False)]
  [string]$AuthenticationPolicySilo,
  [Parameter(Mandatory=$False)]
  [string]$AuthType,
  [Parameter(Mandatory=$False)]
  [securestring]$CannotChangePassword,
  [Parameter(Mandatory=$False)]
  [securestring]$Certificates,
  [Parameter(Mandatory=$False)]
  [SecureString]$ChangePasswordAtLogon,
  [Parameter(Mandatory=$False)]
  [string]$City,
  [Parameter(Mandatory=$False)]
  [string]$Company,
  [Parameter(Mandatory=$False)]
  [string]$CompoundIdentitySupported,
  [Parameter(Mandatory=$False)]
  [string]$Country,
  [Parameter(Mandatory=$False)]
  [SecureString]$Credential,
  [Parameter(Mandatory=$False)]
  [string]$Department,
  [Parameter(Mandatory=$False)]
  [string]$Description,
  [Parameter(Mandatory=$False)]
  [string]$DisplayName,
  [Parameter(Mandatory=$False)]
  [string]$Division,
  [Parameter(Mandatory=$False)]
  [string]$EmailAddress,
  [Parameter(Mandatory=$False)]
  [string]$EmployeeID,
  [Parameter(Mandatory=$False)]
  [string]$EmployeeNumber,
  [Parameter(Mandatory=$False)]
  [string]$Enabled,
  [Parameter(Mandatory=$False)]
  [string]$Fax,
  [Parameter(Mandatory=$False)]
  [string]$GivenName,
  [Parameter(Mandatory=$False)]
  [string]$HomeDirectory,
  [Parameter(Mandatory=$False)]
  [string]$HomeDrive,
  [Parameter(Mandatory=$False)]
  [string]$HomePage,
  [Parameter(Mandatory=$False)]
  [string]$HomePhone,
  [Parameter(Mandatory=$False)]
  [string]$Initials,
  [Parameter(Mandatory=$False)]
  [string]$Instance,
  [Parameter(Mandatory=$False)]
  [string]$KerberosEncryptionType,
  [Parameter(Mandatory=$False)]
  [string]$LogonWorkstations,
  [Parameter(Mandatory=$False)]
  [string]$Manager,
  [Parameter(Mandatory=$False)]
  [string]$MobilePhone,
  [Parameter(Mandatory=$False)]
  [string]$Office,
  [Parameter(Mandatory=$False)]
  [string]$OfficePhone,
  [Parameter(Mandatory=$False)]
  [string]$Organization,
  [Parameter(Mandatory=$False)]
  [string]$OtherName,
  [Parameter(Mandatory=$False)]
  [string]$PassThru,
  [Parameter(Mandatory=$False)]
  [SecureString]$PasswordNeverExpires,
  [Parameter(Mandatory=$False)]
  [SecureString]$PasswordNotRequired,
  [Parameter(Mandatory=$False)]
  [string]$Path,
  [Parameter(Mandatory=$False)]
  [string]$POBox,
  [Parameter(Mandatory=$False)]
  [string]$PostalCode,
  [Parameter(Mandatory=$False)]
  [string]$PrincipalsAllowedToDelegateToAccount,
  [Parameter(Mandatory=$False)]
  [string]$ProfilePath,
  [Parameter(Mandatory=$False)]
  [string]$SamAccountName,
  [Parameter(Mandatory=$False)]
  [string]$ScriptPath,
  [Parameter(Mandatory=$False)]
  [string]$Server,
  [Parameter(Mandatory=$False)]
  [string]$ServicePrincipalNames,
  [Parameter(Mandatory=$False)]
  [string]$SmartcardLogonRequired,
  [Parameter(Mandatory=$False)]
  [string]$State,
  [Parameter(Mandatory=$False)]
  [string]$StreetAddress,
  [Parameter(Mandatory=$False)]
  [string]$Surname,
  [Parameter(Mandatory=$False)]
  [string]$Title,
  [Parameter(Mandatory=$False)]
  [string]$TrustedForDelegation,
  [Parameter(Mandatory=$False)]
  [string]$Type,
  [Parameter(Mandatory=$False)]
  [string]$UserPrincipalName,
  [Parameter(Mandatory=$false)]
  [string]$errorlog,
  [Parameter(Mandatory=$false)]
  [string]$logfile,
  [Parameter(Mandatory=$false)]
  [string]$logfolder
)

Try {
  New-Aduser -name $name -$accountpassword $accountpassword -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
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
