#Connect to vcenter
Import-Module VMware.PowerCLI
set-powercliconfiguration -invalidcertificateaction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Connect-VIServer vcenterp.iso-ne.com
#begin cloning of the system from template (this script mass clones from one template image)
#Variables that are mandatory
$VMHost = "bobthebuilder.iso-ne.com"
$Template = "w2k12r2stdv"
$Datastore = "build-nfs"
$DiskStorageFormat = "thick"
$Location = "Build Servers"
$NetworkName = "Win_Server"
$Memory = "8"
$cpucount = "2"
#format is in gigabytes
$disksize = "150"
#set vmware tools to manual
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec  
$vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo  
$vmConfigSpec.Tools.ToolsUpgradePolicy = "manual"  

#put in the names for the build or use a text file
$newVmList = "EMP32D1A","MODPSED1A","ITAMD1A"
$taskTab = @{}
#example below for creating a new vm
#New-VM -Name test2003 -Template $template -Datastore $datastore -VMHost $VMHost -Location $Location -DiskStorageFormat $DiskStorageFormat -RunAsync

#check the host to make sure it's not overcommited already
#Get-CPUOvercommit

# Create all the VMs specified in $newVmList
foreach($Name in $newVmList){
  $taskTab[(New-VM -Name $Name -Template $template -Datastore $datastore -VMHost $VMHost -Location $Location -DiskStorageFormat $DiskStorageFormat -RunAsync).Id] = $Name
}
 
#Start each VM that is completed and adjust the memory and cpu to the variables from above
#after the memory and cpu have been adjusted then any additional disks can be added

$runningTasks = $taskTab.Count
while($runningTasks -gt 0){
  Get-Task | % {
    if($taskTab.ContainsKey($_.Id) -and $_.State -eq "Success"){
      #set the vcpu and memory
	  $vmName = $taskTab[$_.Id]
	  $VM = Get-VM $vmName | Set-VM -MemoryGB $memory -NumCpu $cpucount –Confirm:$False 
	  #change the disk configuration here
	  Get-HardDisk -VM $vmname | where {$_.Name -eq "Hard disk 1"} | Set-HardDisk -CapacityGB $disksize -Confirm:$false
	  (get-vm -Name $vm).Extensiondata.ReconfigVM($vmConfigSpec) 
	  #get the in process serial number from the vm
	  New-VIProperty -Name BIOSNumber -ObjectType VirtualMachine -Value {
		 param($vmName)
		 $s = ($vm.ExtensionData.Config.Uuid).Replace("-", "")
		 $Uuid = "VMware-"
		 for ($i = 0; $i -lt $s.Length; $i += 2)
		 {
		   $Uuid += ("{0:x2}" -f [byte]("0x" + $s.Substring($i, 2)))
		   if ($Uuid.Length -eq 30) { $Uuid += "-" } else { $Uuid += " " }
		 }
		 $Uuid.TrimEnd()
		} -Force | Out-Null     
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