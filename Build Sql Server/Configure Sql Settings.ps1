#######################################################################################################
#Configure SQL, all SQL servers
#SQL Object
$SQLObject = New-Object Microsoft.SqlServer.Management.Smo.Server
#Getting the server information
$server = New-Object Microsoft.SqlServer.Management.Smo.Server $env:ComputerName
#Configure SQL Memory
$MaxMemory = $($server.PhysicalMemory) - 4096
$MinMemory = $($server.PhysicalMemory) / 2
Invoke-Sqlcmd -Database Master -Query "EXEC sp_configure'Show Advanced Options',1;RECONFIGURE;"
Invoke-Sqlcmd -Database Master -Query "EXEC sp_configure'max server memory (MB)',$MaxMemory;RECONFIGURE;"
Invoke-Sqlcmd -Database Master -Query "EXEC sp_configure'min server memory (MB)',$MinMemory;RECONFIGURE;"
#End Configure SQL, all SQL servers
#######################################################################################################
