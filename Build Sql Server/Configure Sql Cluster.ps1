#######################################################################################################
#Setup and configure cluster (only one node)
#Configure cluster (only run once on eaither node)
New-Cluster –Name $ClusterCNO -Node $node1,$node2 –StaticAddress $clusterip -nostorage
#Configure file share witness folder
If ((Test-Path $filesharewitness) -eq $false)
{
    New-Item -Path $filesharewitness -ItemType Container
}
#Set file share permissions
Start-Process -FilePath "icacls.exe" -ArgumentList """$filesharewitness"" /grant ""YOURDOMAINHERE\$ClusterCNO$"":(OI)(CI)(F) /C" -NoNewWindow -Wait
#Set quorum for the cluster
 
#Note 1: This is for AAG's only, if you are setting up a traditional cluster, you'll need to setup a disk based quorum
Set-ClusterQuorum –NodeAndFileShareMajority $filesharewitness
#Set Cluster Timeout to 10 seconds
(Get-cluster).SameSubnetThreshold=10
#Stop the cluster service so you can give it the correct AD rights
get-cluster -Name $ClusterCNO | Stop-Cluster -Force -Confirm:$false
#!!!!!!!!!!!!!Add the cluster CNO to the same AD group that you added the individual nodes to
#After assigning the rights, start the cluster service
Get-Service -Name ClusSvc -ComputerName $node1 | Start-Service
Get-Service -Name ClusSvc -ComputerName $node2 | Start-Service
#END Setup and configure cluster (only one node)
#######################################################################################################
