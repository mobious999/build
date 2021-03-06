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
$VMHost = "hpesx3.healthpn.com"
$Template = "Windows 2016 Standard"
$Datastore = "NimbleSSD-DS01"
$DiskStorageFormat = "Thick"
$Location = "Development"
$Networklabel = "VM Network .250"
$Memory = "64"
$cpucount = "6"
$cores = "1"
$servertype = "sql"
$disksize = "120"
#format is in gigabytes
$disk2toadd = "120"
$disk3toadd = "100"
$disk4toadd = "5"
$disk5toadd = "20"
$disk6toadd = "5"
$disk7toadd = "125"
$disk8toadd = "5"
#$disk9toadd = "9"

function Addparavirtual {
  #this function adds a paravirtual controller in sequence so that if you call it 3 times you get 3 controllers
  $vm = Get-VM -Name $vm
  $newBusNumber = ($vm.ExtensionData.Config.Hardware.Device |
      Where-Object{$_ -is [VMware.Vim.VirtualSCSIController]} |
      Select-Object -ExpandProperty BusNumber |
      Measure-Object -Maximum |
      Select-Object -ExpandProperty Maximum) + 1
  $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
  $device = New-Object VMware.Vim.VirtualDeviceConfigSpec
  $device.Operation = [VMware.Vim.VirtualDeviceConfigSpecOperation]::add
  $device.Device = New-Object VMware.Vim.ParaVirtualSCSIController
  $device.Device.BusNumber = $newBusNumber
  $spec.DeviceChange += $device
  $vm.ExtensionData.ReconfigVM($spec)
}

#put in the names for the build or use a text file
$newVmList = "WFSQLDEV"
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
    #Set the amount of cpu  
	  $VM = Get-VM $vmName | Set-VM -MemoryGB $memory -NumCpu $cpucount –Confirm:$False 
    #configure the network for the vm
    $VM = Get-vm $vmName | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $Networklabel -Confirm:$false
    #Extend the primary disk configuration to whatever is required
    Get-HardDisk -VM $vmname | Where-Object {$_.Name -eq "Hard disk 1"} | Set-HardDisk -CapacityGB $disksize -Confirm:$false
    #configure controllers and disks 
    Switch($servertype){
      Sql {
         #sql data disks
         Addparavirtual
         New-HardDisk -VM $vmname -CapacityGB $disk2toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
         New-HardDisk -VM $vmname -CapacityGB $disk3toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
         #sql logs / backup / staging disks
         Addparavirtual
         New-HardDisk -VM $vmname -CapacityGB $disk4toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 2"
         New-HardDisk -VM $vmname -CapacityGB $disk5toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 2"
         New-HardDisk -VM $vmname -CapacityGB $disk6toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 2"
         #sql tempdb disks 
         Addparavirtual
         New-HardDisk -VM $vmname -CapacityGB $disk7toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 3"
         New-HardDisk -VM $vmname -CapacityGB $disk8toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 3"
         #New-HardDisk -VM $vmname -CapacityGB $disk9toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 3"   
      }
      Web{
          #standard web server 1 drive for content and one for logs
          Addparavirtual
          New-HardDisk -VM $vmname -CapacityGB $disk1toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
          New-HardDisk -VM $vmname -CapacityGB $disk2toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
      }
       App{
          #standard app server with one external drive
          Addparavirtual
          New-HardDisk -VM $vmname -CapacityGB $disk1toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
          New-HardDisk -VM $vmname -CapacityGB $disk2toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
      }
       Exchange{
          #tailor to your exchange requirements
          Addparavirtual
          New-HardDisk -VM $vmname -CapacityGB $disk1toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
          New-HardDisk -VM $vmname -CapacityGB $disk2toadd -StorageFormat $DiskStorageFormat -Controller "SCSI controller 1"
      }
    }  
    #configure the cores per socket using a virtual machine spec
    #$VM = Get-VM -Name $Vmname
		$VMSpec = New-Object –Type VMware.Vim.VirtualMAchineConfigSpec –Property @{“NumCoresPerSocket” = $cores}
		$vmname.ExtensionData.ReconfigVM_Task($VMSpec) 
	  (get-vm -Name $vmname).Extensiondata.ReconfigVM($vmConfigSpec) 
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