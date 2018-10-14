#######################################################################################################
#Setup the AAG (only one node)
 
#Create the endpoints for each SQL AAG replica
New-SqlHADREndpoint -Path "SQLSERVER:\SQL\$($node1)\Default" -Name $($SQLAAGEndPointName) -Port 5022 -EncryptionAlgorithm Aes -Encryption Required
New-SqlHADREndpoint -Path "SQLSERVER:\SQL\$($node2)\Default" -Name $($SQLAAGEndPointName) -Port 5022 -EncryptionAlgorithm Aes -Encryption Required
 
#Stare the endpoints for each AAG replica
Set-SqlHADREndpoint -Path "SQLSERVER:\SQL\$($node1)\Default\Endpoints\$($SQLAAGEndPointName)" -State Started
Set-SqlHADREndpoint -Path "SQLSERVER:\SQL\$($node2)\Default\Endpoints\$($SQLAAGEndPointName)" -State Started
 
#Create a SQL login for the SQL service account so each server can connect to each other.
$createLogin = “CREATE LOGIN [$($sqlserviceuser)] FROM WINDOWS;”
$grantConnectPermissions = “GRANT CONNECT ON ENDPOINT::$($SQLAAGEndPointName) TO [$($sqlserviceuser)];”
Invoke-SqlCmd -ServerInstance $($node1) -Query $createLogin
Invoke-SqlCmd -ServerInstance $($node1) -Query $grantConnectPermissions
Invoke-SqlCmd -ServerInstance $($node2) -Query $createLogin
Invoke-SqlCmd -ServerInstance $($node2) -Query $grantConnectPermissions
 
#Create replicas
##########This is for non-seeded AAG's (traditional backup / restore AAGs)
 
#Create the replicas
$primaryReplica = New-SqlAvailabilityReplica -Name $($node1) -EndpointUrl “TCP://$($node1).YOURDOMAINHERE.local:5022” -AvailabilityMode “SynchronousCommit” -FailoverMode 'Automatic' -AsTemplate -Version $SQLObject.version
$secondaryReplica = New-SqlAvailabilityReplica -Name $($node2) -EndpointUrl “TCP://$($node2).YOURDOMAINHERE.local:5022” -AvailabilityMode “SynchronousCommit” -FailoverMode 'Automatic' -AsTemplate -Version $SQLObject.version
 
#Buildthe AAG's
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG1Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -Database $DB1Name -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG2Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -Database $DB2Name -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG3Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -Database $DB3Name -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG4Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -Database $DB4Name -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
 
#Now we need to backup all db's (both full and log)
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB1Name -BackupFile $TestDB1FullPath
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB2Name -BackupFile $TestDB2FullPath
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB3Name -BackupFile $TestDB3FullPath
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB4Name -BackupFile $TestDB4FullPath
 
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB1Name -BackupFile $TestLog1FullPath -BackupAction Log
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB2Name -BackupFile $TestLog2FullPath -BackupAction Log
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB3Name -BackupFile $TestLog3FullPath -BackupAction Log
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB4Name -BackupFile $TestLog4FullPath -BackupAction Log
 
#Now we need to restore the DB's
Restore-SqlDatabase -Database $DB1Name -BackupFile $TestDB1FullPath -ServerInstance $($node2) -NoRecovery
Restore-SqlDatabase -Database $DB2Name -BackupFile $TestDB2FullPath -ServerInstance $($node2) -NoRecovery
Restore-SqlDatabase -Database $DB3Name -BackupFile $TestDB3FullPath -ServerInstance $($node2) -NoRecovery
Restore-SqlDatabase -Database $DB4Name -BackupFile $TestDB4FullPath -ServerInstance $($node2) -NoRecovery
 
Restore-SqlDatabase -Database $DB1Name -BackupFile $TestLog1FullPath -ServerInstance $($node2) -NoRecovery -RestoreAction 'Log'
Restore-SqlDatabase -Database $DB2Name -BackupFile $TestLog2FullPath -ServerInstance $($node2) -NoRecovery -RestoreAction 'Log'
Restore-SqlDatabase -Database $DB3Name -BackupFile $TestLog3FullPath -ServerInstance $($node2) -NoRecovery -RestoreAction 'Log'
Restore-SqlDatabase -Database $DB4Name -BackupFile $TestLog4FullPath -ServerInstance $($node2) -NoRecovery -RestoreAction 'Log'
 
#Now we need to join the secondary nodes copy of the DB to the AAG
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node2)\Default\AvailabilityGroups\$($AAG1Name)" -Database $DB1Name
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node2)\default\AvailabilityGroups\$($AAG2Name)" -Database $DB2Name
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node2)\default\AvailabilityGroups\$($AAG3Name)" -Database $DB3Name
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node2)\default\AvailabilityGroups\$($AAG4Name)" -Database $DB4Name
 
########## END This is for non-seeded AAG's (traditional backup / restore AAGs)
 
#This is for seeded DB's, which is what we're doing in SQL 2017+
 
#Create the replica's
$primaryReplica = New-SqlAvailabilityReplica -Name $($node1) -EndpointUrl “TCP://$($node1).YOURDOMAINHERE.local:5022” -AvailabilityMode “SynchronousCommit” -FailoverMode 'Automatic' -AsTemplate -Version $SQLObject.version -SeedingMode Automatic
$secondaryReplica = New-SqlAvailabilityReplica -Name $($node2) -EndpointUrl “TCP://$($node2).YOURDOMAINHERE.local:5022” -AvailabilityMode “SynchronousCommit” -FailoverMode 'Automatic' -AsTemplate -Version $SQLObject.version -SeedingMode Automatic
 
#Create the AAG
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG1Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG2Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG3Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
New-SqlAvailabilityGroup -InputObject $($node1) -Name $AAG4Name -AvailabilityReplica ($primaryReplica, $secondaryReplica) -DtcSupportEnabled -DatabaseHealthTrigger -ClusterType Wsfc
 
#Join secondary node to the AAG's
Join-SqlAvailabilityGroup -Path “SQLSERVER:\SQL\$($node2)\Default” -Name $AAG1Name
Join-SqlAvailabilityGroup -Path “SQLSERVER:\SQL\$($node2)\Default” -Name $AAG2Name
Join-SqlAvailabilityGroup -Path “SQLSERVER:\SQL\$($node2)\Default” -Name $AAG3Name
Join-SqlAvailabilityGroup -Path “SQLSERVER:\SQL\$($node2)\Default” -Name $AAG4Name
 
#Grant the AAG the rights to create a DB (only needed for seeding mode)
$AAG1CreateCommand = "ALTER AVAILABILITY GROUP [$($AAG1Name)] GRANT CREATE ANY DATABASE"
$AAG2CreateCommand = "ALTER AVAILABILITY GROUP [$($AAG2Name)] GRANT CREATE ANY DATABASE"
$AAG3CreateCommand = "ALTER AVAILABILITY GROUP [$($AAG3Name)] GRANT CREATE ANY DATABASE"
$AAG4CreateCommand = "ALTER AVAILABILITY GROUP [$($AAG4Name)] GRANT CREATE ANY DATABASE"
 
Invoke-SqlCmd -ServerInstance $($node1) -Query $AAG1CreateCommand
Invoke-SqlCmd -ServerInstance $($node2) -Query $AAG1CreateCommand
 
Invoke-SqlCmd -ServerInstance $($node1) -Query $AAG2CreateCommand
Invoke-SqlCmd -ServerInstance $($node2) -Query $AAG2CreateCommand
 
Invoke-SqlCmd -ServerInstance $($node1) -Query $AAG3CreateCommand
Invoke-SqlCmd -ServerInstance $($node2) -Query $AAG3CreateCommand
 
Invoke-SqlCmd -ServerInstance $($node1) -Query $AAG4CreateCommand
Invoke-SqlCmd -ServerInstance $($node2) -Query $AAG4CreateCommand
 
#Now we need to join the primary nodes copy of the DB to the AAG
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node1)\Default\AvailabilityGroups\$($AAG1Name)" -Database $DB1Name
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node1)\default\AvailabilityGroups\$($AAG2Name)" -Database $DB2Name
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node1)\default\AvailabilityGroups\$($AAG3Name)" -Database $DB3Name
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$($node1)\default\AvailabilityGroups\$($AAG4Name)" -Database $DB4Name
 
#Now we need to setup the listners (for both seeded and non-seeded AAG's)
New-SqlAvailabilityGroupListener -Name $($AAG1Name) -staticIP $AAG1IP -Port 1433 -Path "SQLSERVER:\SQL\$($node1)\DEFAULT\AvailabilityGroups\$($AAG1Name)"
New-SqlAvailabilityGroupListener -Name $($AAG2Name) -staticIP $AAG2IP -Port 1433 -Path "SQLSERVER:\SQL\$($node1)\DEFAULT\AvailabilityGroups\$($AAG2Name)"
New-SqlAvailabilityGroupListener -Name $($AAG3Name) -staticIP $AAG3IP -Port 1433 -Path "SQLSERVER:\SQL\$($node1)\DEFAULT\AvailabilityGroups\$($AAG3Name)"
New-SqlAvailabilityGroupListener -Name $($AAG4Name) -staticIP $AAG4IP -Port 1433 -Path "SQLSERVER:\SQL\$($node1)\DEFAULT\AvailabilityGroups\$($AAG4Name)"
 
#End Setup the AAG (only one node)
#######################################################################################################
