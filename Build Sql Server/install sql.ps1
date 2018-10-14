#######################################################################################################
#Install SQL
#Copy the ISO to
Copy-item -Path $ISOFileSource -Destination $ISOFileDestination -Force -Confirm:$false
#Copy the SQL config file
Copy-item -path $ConfigFileSource -Destination $ConfigFileDestination -Force -Container:$false
#Copy the SSMS to the K:
Copy-item -path $SSMSFileSource -Destination $SSMSFileDestination -Force -Container:$false
#Modfiy the config file to update it for our SQL accounts
$ConfigFileContent = (Get-content -Path $ConfigFileDestination).Replace("YOURDOMAINHERE\SQLSERVICEACCOUNTTOCHANGE",$sqlserviceuser) | set-content -Path $ConfigFileDestination
$ConfigFileContent = (Get-content -Path $ConfigFileDestination).Replace("YOURDOMAINHERE\SQLAGENTACCOUNTTOCHANGE",$sqlagentuser) | set-content -Path $ConfigFileDestination
#Mount the ISO
$mountResult = Mount-DiskImage $ISOFileDestination -PassThru
$ISOVolume = $mountResult | Get-Volume
#Define the SQL install path
$SQLInstallPath = $($isovolume.driveletter) + ":\setup.exe"
#Install SQL
Start-Process -FilePath $SQLInstallPath -ArgumentList "/SQLSVCPASSWORD=""$sqlserviceuserpassword"" /AGTSVCPASSWORD=""$sqlagentuserpassword"" /ISSVCPASSWORD=""$sqlserviceuserpassword"" /ASSVCPASSWORD=""$sqlserviceuserpassword"" /ConfigurationFile=$($ConfigFileDestination) /IAcceptSQLServerLicenseTerms" -NoNewWindow -Wait
#Install SSSMS
Start-Process -FilePath $SSMSFileDestination -ArgumentList "/passive /norestart" -NoNewWindow -Wait
#END Install SQL
#######################################################################################################
