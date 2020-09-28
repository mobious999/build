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
Connect-VIServer aquila.healthpn.com
#begin cloning of the system from template (this script mass clones from one template image)
#Variables that are mandatory
$VMHost = "corvus.healthpn.com"
$Template = "Windows 2016 Standard"
$Datastore = "3PAR-DS04"
$DiskStorageFormat = "Thick"
$Location = "Development"
$NetworkName = "VM Network .250"
$Memory = "4"
$cpucount = "2"
$cores = "1"
#format is in gigabytes
$disksize = "120"
$seconddisk = "2"
$thirddisk = "3"
$fourthdisk = "4"
$fifthdisk = "5"
$sixthdisk = "6"
$seventhdisk ="7"

#fix list
# check the size of the vm template - if eq then disregard
# add if else to all disk adds
# get network labels dynamically 
# get datastores dynamically and pick the best one with most free space

#set vmware tools to manual
#$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec  
#$vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo  
#$vmConfigSpec.Tools.ToolsUpgradePolicy = "manual"  

#put in the names for the build or use a text file
$newVmList = "testsql2"
$taskTab = @{}

# Create all the VMs specified in $newVmList
foreach($Name in $newVmList){
  $taskTab[(New-VM -Name $Name -Template $template -Datastore $datastore -VMHost $VMHost -Location $Location -DiskStorageFormat $DiskStorageFormat -RunAsync).Id] = $Name
}
 
$runningTasks = $taskTab.Count
while($runningTasks -gt 0){
  Get-Task | ForEach-Object {
    if($taskTab.ContainsKey($_.Id) -and $_.State -eq "Success"){
    #set the vcpu and memory
	  $vmName = $taskTab[$_.Id]
	  $VM = Get-VM $vmName | Set-VM -MemoryGB $memory -NumCpu $cpucount –Confirm:$False 
	  #change the primary disk configuration here
    Get-HardDisk -VM $vmname | Where-Object {$_.Name -eq "Hard disk 1"} | Set-HardDisk -CapacityGB $disksize -Confirm:$false
    #change the second disk 
    #$VM = Get-VM -Name $VMName -ErrorAction Stop
    #$Hd = New-HardDisk -VM $VM -CapacityGB $DiskSizeGB -StorageFormat Thin
    #Create Machine Config Specification Object
    #$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
    #Set spec to vm
    #$spec.ChangeVersion = $vm.ExtensionData.Config.ChangeVersion
    #Create Device Config Specification Object
    #$diskconfig = New-Object VMware.Vim.VirtualDeviceConfigSpec
    #set diskconfig to hard drive just added
    #$diskconfig.device = $HD.ExtensionData
    #set the unit number to whatever you want here(for example 0:3 becomes 0:7)
    #this only changes the second number (the BUS) not the first number (the SCSI Controller)
    #$diskconfig.device.UnitNumber = 7
    #apply the edit to the machine specification
    #$vm.ExtensionData.ReconfigVM($spec)
    ###########################################################################################################  
      #change or add the second disk
      #usually the sql data drive for the time being disk 2:0
      $Hd = New-HardDisk -VM $VM -CapacityGB $seconddisk -StorageFormat $DiskStorageFormat | New-ScsiController -Type Paravirtual
    ###########################################################################################################
      #change the third disk
      # disk controller id 2:01
      $Hd = New-HardDisk -VM $VM -CapacityGB $thirddisk -StorageFormat $DiskStorageFormat 
      #Create Machine Config Specification Object
      $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
      #Set spec to vm
      $spec.ChangeVersion = $vm.ExtensionData.Config.ChangeVersion
      #Create Device Config Specification Object
      $diskconfig = New-Object VMware.Vim.VirtualDeviceConfigSpec
      #set diskconfig to hard drive just added
      $diskconfig.device = $HD.ExtensionData
      #set the unit number to whatever you want here(for example 0:3 becomes 0:7)
      #this only changes the second number (the BUS) not the first number (the SCSI Controller)
      $diskconfig.device.UnitNumber = 1
      #apply the edit to the machine specification
      $diskconfig.operation = "edit"
      $spec.DeviceChange += $diskconfig
      $vm.ExtensionData.ReconfigVM($spec)
    ###########################################################################################################
      #change the fourth disk
      #usually scsi id is 3:0
      $Hd = New-HardDisk -VM $VM -CapacityGB $fourthdisk -StorageFormat $DiskStorageFormat | New-ScsiController -Type Paravirtual   
    ###########################################################################################################
      #change the fifth disk
      #usually scsi id is 3:1
      $Hd = New-HardDisk -VM $VM -CapacityGB $fifthdisk -StorageFormat $DiskStorageFormat 
      #Create Machine Config Specification Object
      $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
      #Set spec to vm
      $spec.ChangeVersion = $vm.ExtensionData.Config.ChangeVersion
      #Create Device Config Specification Object
      $diskconfig = New-Object VMware.Vim.VirtualDeviceConfigSpec
      #set diskconfig to hard drive just added
      $diskconfig.device = $HD.ExtensionData
      #set the unit number to whatever you want here(for example 0:3 becomes 0:7)
      #this only changes the second number (the BUS) not the first number (the SCSI Controller)
      $diskconfig.device.UnitNumber = 1
      #apply the edit to the machine specification
      $diskconfig.operation = "edit"
      $spec.DeviceChange += $diskconfig
      $vm.ExtensionData.ReconfigVM($spec)
    ###########################################################################################################  
      #change the sixth disk
      #usually scsi id is 3:2
      $Hd = New-HardDisk -VM $VM -CapacityGB $sixthdisk -StorageFormat $DiskStorageFormat 
      #Create Machine Config Specification Object
      $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
      #Set spec to vm
      $spec.ChangeVersion = $vm.ExtensionData.Config.ChangeVersion
      #Create Device Config Specification Object
      $diskconfig = New-Object VMware.Vim.VirtualDeviceConfigSpec
      #set diskconfig to hard drive just added
      $diskconfig.device = $HD.ExtensionData
      #set the unit number to whatever you want here(for example 0:3 becomes 0:7)
      #this only changes the second number (the BUS) not the first number (the SCSI Controller)
      $diskconfig.device.UnitNumber = 2
      #apply the edit to the machine specification
      $diskconfig.operation = "edit"
      $spec.DeviceChange += $diskconfig
      $vm.ExtensionData.ReconfigVM($spec)
    ###########################################################################################################  
      #change the seventh disk
      #usually scsi id is 3:3
      $Hd = New-HardDisk -VM $VM -CapacityGB $seventhdisk -StorageFormat $DiskStorageFormat 
      #Create Machine Config Specification Object
      $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
      #Set spec to vm
      $spec.ChangeVersion = $vm.ExtensionData.Config.ChangeVersion
      #Create Device Config Specification Object
      $diskconfig = New-Object VMware.Vim.VirtualDeviceConfigSpec
      #set diskconfig to hard drive just added
      $diskconfig.device = $HD.ExtensionData
      #set the unit number to whatever you want here(for example 0:3 becomes 0:7)
      #this only changes the second number (the BUS) not the first number (the SCSI Controller)
      $diskconfig.device.UnitNumber = 3
      #apply the edit to the machine specification
      $diskconfig.operation = "edit"
      $spec.DeviceChange += $diskconfig
      $vm.ExtensionData.ReconfigVM($spec)
    ###########################################################################################################
    #configure the cores per socket using a virtual machine spec
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