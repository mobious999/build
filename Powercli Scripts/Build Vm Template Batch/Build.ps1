<#
.SYNOPSIS
  This script can be used to build lots of vm's from templates
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    Required fields
.INPUTS
    Not really required but tailor them to your environment
.OUTPUTS
    
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>


#Connect to vcenter
Import-Module VMware.PowerCLI
set-powercliconfiguration -invalidcertificateaction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Connect-VIServer vcenterp.iso-ne.com
#begin cloning of the system from template (this script mass clones from one template image)
#Variables that are mandatory
$VMHost = "esx hostname"
$Template = "templatename"
$Datastore = "datastore for build"
$DiskStorageFormat = "thick"
$Location = "Vm folder for the builds"
$NetworkName = "network label name"
$Memory = "amount of memory"
$cpucount = "amount of cpu"
$cores = "amount of cores"
#format is in gigabytes
$disksize = "disk size in gigabytes"
#set vmware tools to manual
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec  
$vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo  
$vmConfigSpec.Tools.ToolsUpgradePolicy = "manual"  

#put in the names for the build or use a text file
$newVmList = "hostname","hostname1","hostname3"
$taskTab = @{}

# Create all the VMs specified in $newVmList
foreach($Name in $newVmList){
  $taskTab[(New-VM -Name $Name -Template $template -Datastore $datastore -VMHost $VMHost -Location $Location -DiskStorageFormat $DiskStorageFormat -RunAsync).Id] = $Name
}
 
$runningTasks = $taskTab.Count
while($runningTasks -gt 0){
  Get-Task | % {
    if($taskTab.ContainsKey($_.Id) -and $_.State -eq "Success"){
      #set the vcpu and memory
	  $vmName = $taskTab[$_.Id]
	  $VM = Get-VM $vmName | Set-VM -MemoryGB $memory -NumCpu $cpucount –Confirm:$False 
	  #change the disk configuration here
		Get-HardDisk -VM $vmname | where {$_.Name -eq "Hard disk 1"} | Set-HardDisk -CapacityGB $disksize -Confirm:$false
		$VM = Get-VM -Name $Vmname
		$VMSpec = New-Object –Type VMware.Vim.VirtualMAchineConfigSpec –Property @{“NumCoresPerSocket” = $cores}
		$VM.ExtensionData.ReconfigVM_Task($VMSpec) 
	  (get-vm -Name $vm).Extensiondata.ReconfigVM($vmConfigSpec) 
      $taskTab.Remove($_.Id)
      $runningTasks--
    }
    elseif($taskTab.ContainsKey($_.Id) -and $_.State -eq "Error"){
      $taskTab.Remove($_.Id)
      $runningTasks--
    }
  }
  Start-Sleep -Seconds 15
}