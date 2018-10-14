#######################################################################################################
#Fix cluster setting and test cluster post AAG (only one node)
#Fix cluster multi-subnet SQL listner setting
$ClusterResource = Get-ClusterResource | Where-Object {$_.ResourceType -eq "network name" -and $_.ownergroup -ne "Cluster Group"}
$ClusterResource | Set-ClusterParameter -Create RegisterAllProvidersIP 0
$ClusterResource | ForEach-Object {Stop-ClusterResource -Name $_.Name}
Get-ClusterResource | Where-Object {$_.ResourceType -eq "SQL Server Availability Group"} | foreach-object {Start-ClusterResource -Name $_.Name}
#Finally test the cluster
Test-Cluster
#END Fix cluster setting and test cluster post AAG(only one node)
#######################################################################################################
