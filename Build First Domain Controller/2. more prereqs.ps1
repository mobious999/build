$Policy = "RemoteSigned"
If ((get-ExecutionPolicy) -ne $Policy) {
  Set-ExecutionPolicy $Policy -Force
  Exit
}

#Install AD DS, DNS and GPMC 
$featureLogPath = "c:\adbuild.txt" 
start-job -Name addFeature -ScriptBlock { 
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools } 
Wait-Job -Name addFeature 
Get-WindowsFeature | Where installed >>$featureLogPath
Restart-Computer