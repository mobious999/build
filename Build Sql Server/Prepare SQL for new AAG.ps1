#######################################################################################################
#Prepare SQL for new AAG (only one node)
#Create a DB per listener. Typically two, but sometimes more / less
#DB1
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($SQLObject, $DB1Name)
$db.Create()
#DB2
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($SQLObject, $DB2Name)
$db.Create()
#DB3
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($SQLObject, $DB3Name)
$db.Create()
#DB4
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($SQLObject, $DB4Name)
$db.Create()
#Confirm, list databases in your current instance
$SQLObject.Databases | Select-Object Name, Status, Owner, CreateDate
#Configure the backup share
If ((Test-Path $BackupSharePath) -eq $false)
{
New-Item -Path $BackupSharePath -ItemType Container
}
#Now we need to backup all of the newly created DB's
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB1Name -BackupFile $TestDB1FullPath
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB2Name -BackupFile $TestDB2FullPath
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB3Name -BackupFile $TestDB3FullPath
Backup-SqlDatabase -ServerInstance $($env:ComputerName) -database $DB4Name -BackupFile $TestDB4FullPath
#END Prepare SQL for new AAG (only one node)
#######################################################################################################
