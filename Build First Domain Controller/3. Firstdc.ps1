$Policy = "RemoteSigned"
If ((get-ExecutionPolicy) -ne $Policy) {
  Set-ExecutionPolicy $Policy -Force
  Exit
}

# Create New Forest, add Domain Controller 
#static variables
$domainfull = "Quinn.local"
$domainnetbios = "Quinn"
write-host $domainfull

$SafeModeAdministratorPasswordText = "Password123"
$SafeModeAdministratorPassword = ConvertTo-SecureString -AsPlainText $SafeModeAdministratorPasswordText -Force
Import-Module ADDSDeployment 
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainName $domainfull -DomainNetbiosName $domainnetbios -DomainMode "7" -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $SafeModeAdministratorPassword
