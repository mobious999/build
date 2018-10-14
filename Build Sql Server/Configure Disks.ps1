#######################################################################################################
 
#Setting up the physical disks
#Get all offline disks, should be any disks you've created
$OfflineDisks = Get-Disk | Where-Object {$_.OperationalStatus -eq "Offline"}
#Set Disk online
$OfflineDisks | Set-Disk -IsOffline:$false
#Disable read only
$OfflineDisks | Set-Disk -IsReadOnly:$false
#Initialize Disks
$OfflineDisks | Initialize-Disk -PartitionStyle GPT
 
#loop through all disks and configure based on thier location. This location is based on VMware controller card and controller port locations. In VMware you should have the following SCSI configs
#0:0 = C: = OS = disk 1
#0:1 = K: = Misc = disk 2
#1:0 = F: = UserDB1 = disk 3
#1:1 = N: = Index1 = disk 4
#2:0 = J: = UserLog1 = disk 5
#3:0 = V: = TempLog = disk 6
#3:1 = W: = TempDB = disk 7
 
#Microsoft in their infinite wisdom, continues to change f'ing property values around, so below is the server 2016 specific scsi id
Foreach ($disk in $OfflineDisks)
{
    #This will give us the view of which SCSI card and port we're in.
    #Note: property "SCSIPort" actually equals SCSI card in WMI, and "SCSITargetId" equals the SCSI port for the card
    $WMIDiskInformation = get-wmiobject -Class win32_diskdrive | where-object {$_.DeviceID -like "*$($disk.number)"}
     if ($WMIDiskInformation.SCSIPort -eq 2 -and $WMIDiskInformation.SCSITargetId -eq 1)
{
    Write-Output "K:"
    $disk | New-Partition -UseMaximumSize
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "Misc" -Confirm:$false
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Set-Partition -NewDriveLetter k
}
Elseif ($WMIDiskInformation.SCSIPort -eq 3 -and $WMIDiskInformation.SCSITargetId -eq 0)
{
    Write-Output "V:"
    $disk | New-Partition -UseMaximumSize
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "TempLog" -Confirm:$false
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Set-Partition -NewDriveLetter V
}
Elseif ($WMIDiskInformation.SCSIPort -eq 3 -and $WMIDiskInformation.SCSITargetId -eq 1)
{
    Write-Output "w:"
    $disk | New-Partition -UseMaximumSize
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Format-Volume -FileSystem NTFS -AllocationUnitSize 8192 -NewFileSystemLabel "TempDB" -Confirm:$false
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Set-Partition -NewDriveLetter w
}
Elseif ($WMIDiskInformation.SCSIPort -eq 4 -and $WMIDiskInformation.SCSITargetId -eq 0)
{
    Write-Output "F:"
    $disk | New-Partition -UseMaximumSize
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Format-Volume -FileSystem NTFS -AllocationUnitSize 8192 -NewFileSystemLabel "UserDB1" -Confirm:$false
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Set-Partition -NewDriveLetter f
}
 
Elseif ($WMIDiskInformation.SCSIPort -eq 4 -and $WMIDiskInformation.SCSITargetId -eq 1)
{
    Write-Output "N:"
    $disk | New-Partition -UseMaximumSize
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Format-Volume -FileSystem NTFS -AllocationUnitSize 8192 -NewFileSystemLabel "Index1" -Confirm:$false
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Set-Partition -NewDriveLetter n
}
Elseif ($WMIDiskInformation.SCSIPort -eq 5 -and $WMIDiskInformation.SCSITargetId -eq 0)
{
    Write-Output "J:"
    $disk | New-Partition -UseMaximumSize
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "UserLog1" -Confirm:$false
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Set-Partition -NewDriveLetter j
}
Elseif ($WMIDiskInformation.SCSIPort -eq 4 -and $WMIDiskInformation.SCSITargetId -eq 2)
{
    Write-Output "G:"
    $disk | New-Partition -UseMaximumSize
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Format-Volume -FileSystem NTFS -AllocationUnitSize 8192 -NewFileSystemLabel "UserDB2" -Confirm:$false
    $disk | Get-Partition | Where-Object {$_.type -eq "Basic"} | Set-Partition -NewDriveLetter G
}
 
}
#END Setting up the physical disks
#######################################################################################################
#######################################################################################################
 
#Setting up the folder paths and permissions
# Note 1: If you have more than the standard F, J, K, N, V and W drives, you'll need to mananually setup the folder structure and permsissions
# Note 2: As part of the SQL install, SQL will configure the modify permissions for the default DB, Log, TempLog and TempDB folders, which is why I don't configure them.
# NOte 3: Keep an eye on the folder permissions, you shouldn't see a lot of errors, if you do, something went wrong.
# Note 4: These are based on default disk locations and default disk requests. if you get a request for a G: drive for example, we don't have that scripted at the moment.
 
#Create Folder Stucture
#F: Drive
If ((Test-Path "F:\MSSQLDB\Data") -eq $false)
{
    New-Item -Path "F:\MSSQLDB\Data" -ItemType Container
}
 
If ((Test-Path "F:\OLAP\Data") -eq $false)
{
    New-Item -Path "F:\OLAP\Data" -ItemType Container
}

#J: Drive
 
If ((Test-Path "J:\MSSQLDB\Log") -eq $false)
{
    New-Item -Path "J:\MSSQLDB\Log" -ItemType Container
}
 
If ((Test-Path "J:\OLAP\Log") -eq $false)
{
    New-Item -Path "J:\OLAP\Log" -ItemType Container
}

#K: Drive
If ((Test-Path "K:\Config") -eq $false)
{
    New-Item -Path "K:\Config" -ItemType Container
}
 
If ((Test-Path "K:\MSSQL") -eq $false)
{
    New-Item -Path "K:\MSSQL" -ItemType Container
}
 
If ((Test-Path "K:\MSSQLDB") -eq $false)
{
    New-Item -Path "K:\MSSQLDB" -ItemType Container
}
 
If ((Test-Path "K:\OLAP\config") -eq $false)
{
    New-Item -Path "K:\OLAP\config" -ItemType Container
}
 
If ((Test-Path "K:\Support") -eq $false)
{
    New-Item -Path "K:\Support" -ItemType Container
}
#N: Drive
If ((Test-Path "N:\MSSQLDB\Index") -eq $false)
{
    New-Item -Path "N:\MSSQLDB\Index" -ItemType Container
}
#V: Drive
If ((Test-Path "V:\MSSQLDB\Log") -eq $false)
{
    New-Item -Path "V:\MSSQLDB\Log" -ItemType Container
}
#W: Drive
If ((Test-Path "W:\MSSQLDB\Data") -eq $false)
{
    New-Item -Path "W:\MSSQLDB\Data" -ItemType Container
}
 
If ((Test-Path "W:\OLAP\Temp") -eq $false)
{
    New-Item -Path "W:\OLAP\Temp" -ItemType Container
}
#Adding a catch for the G: drive
    $GDRive = Get-PSDrive | Where-Object {$_.root -like "G:*"}
If ($GDRive -ne $null)
{
    If ((Test-Path "G:\MSSQLDB\Data") -eq $false)
{
    New-Item -Path "G:\MSSQLDB\Data" -ItemType Container
}
 
If ((Test-Path "G:\OLAP\Data") -eq $false)
{
    New-Item -Path "G:\OLAP\Data" -ItemType Container
}
}
 
#Set Permissions
#F: Drive
Start-Process -FilePath "icacls.exe" -ArgumentList "f:\ /remove Everyone /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "f:\ /remove ""Creator Owner"" /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "f:\ /remove BUILTIN\Users /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "f: /grant:rx ""$sqlserviceuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "f: /grant:rx ""$sqlagentuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
#J: Drive
Start-Process -FilePath "icacls.exe" -ArgumentList "j:\ /remove Everyone /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "j:\ /remove ""Creator Owner"" /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "j:\ /remove BUILTIN\Users /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "j: /grant:rx ""$sqlserviceuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "j: /grant:rx ""$sqlagentuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
#K: Drive
Start-Process -FilePath "icacls.exe" -ArgumentList "k:\ /remove Everyone /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "k:\ /remove ""Creator Owner"" /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "k:\ /remove BUILTIN\Users /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "k: /grant:rx ""$sqlserviceuser"":(OI)(CI)(M) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "k: /grant:rx ""$sqlagentuser"":(OI)(CI)(M) /C" -NoNewWindow -Wait
#N: Drive
Start-Process -FilePath "icacls.exe" -ArgumentList "n:\ /remove Everyone /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "n:\ /remove ""Creator Owner"" /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "n:\ /remove BUILTIN\Users /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "n: /grant:rx ""$sqlserviceuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "n: /grant:rx ""$sqlagentuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "N:\MSSQLDB\Index /grant:rx ""$sqlserviceuser"":(OI)(CI)(F) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "N:\MSSQLDB\Index /grant:rx ""$sqlagentuser"":(OI)(CI)(F) /C" -NoNewWindow -Wait
#V: Drive
Start-Process -FilePath "icacls.exe" -ArgumentList "v:\ /remove Everyone /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "v:\ /remove ""Creator Owner"" /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "v:\ /remove BUILTIN\Users /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "v: /grant:rx ""$sqlserviceuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "v: /grant:rx ""$sqlagentuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
#W: Drive
Start-Process -FilePath "icacls.exe" -ArgumentList "w:\ /remove Everyone /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "w:\ /remove ""Creator Owner"" /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "w:\ /remove BUILTIN\Users /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "w: /grant:rx ""$sqlserviceuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "w: /grant:rx ""$sqlagentuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
#Adding a catch for the G: drive
If ($GDRive -ne $null)
{
Start-Process -FilePath "icacls.exe" -ArgumentList "g:\ /remove Everyone /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g:\ /remove ""Creator Owner"" /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g:\ /remove BUILTIN\Users /T" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g: /grant:rx ""$sqlserviceuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g: /grant:rx ""$sqlagentuser"":(OI)(CI)(RX) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g:\MSSQLDB\Data /grant:rx ""$sqlserviceuser"":(OI)(CI)(F) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g:\MSSQLDB\Data /grant:rx ""$sqlagentuser"":(OI)(CI)(F) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g:\OLAP\DATA /grant:rx ""$sqlserviceuser"":(OI)(CI)(F) /C" -NoNewWindow -Wait
Start-Process -FilePath "icacls.exe" -ArgumentList "g:\OLAP\DATA /grant:rx ""$sqlagentuser"":(OI)(CI)(F) /C" -NoNewWindow -Wait
}
#END Setting up the folder paths and permissions
 
#######################################################################################################
#At this stage, we have all our disks setup and ready to go.  Next we want to grant the SQL service accounts the “perform volume maintenance tasks” right.  
#I don’t have my function published yet, still working on honing it a bit more.  However, you can easily do this step manually, or until I release the function, which should be soon.  
#I did however want to show the code.
#################################################################################################</h6>
#Add SQL service account and agent to perform volume maintenance tasks local GPO
#NOTE: You can find this setting buried in Computer\Windows\Security\Local Policies\User Rights Assignment
#Copy our function to the temp directory
#Copy-item -Path $LocalGPOFunctionFilePath -Destination $TempDirectory -Force -Confirm:$false
#Function Name to load
#Import function
#. $LocalGPOFunctionNameTempPath
#Add the service account
#Add-ECSLocalGPOUserRightAssignment -UserOrGroup $sqlserviceuser -UserRightAssignment "SeManageVolumePrivilege"
#Add the agent account
#Add-ECSLocalGPOUserRightAssignment -UserOrGroup $sqlagentuser -UserRightAssignment "SeManageVolumePrivilege"
#END Add SQL service account and agent to perform volume maitanance tasks local GPO
####################################################################