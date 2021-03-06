<#
.SYNOPSIS
  This script can be used to build a blank vm and then have it boot for an os installation
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    Required fields
	$Vmname = Name of the virtual machine
	$hostname = esx host to start the build on
	$datastore = the datastore to build the vm on
	$firstdisksize = This is the boot disk of the machine
	$seconddisksize = Second disk if needed
	$thirddisksize = Third disk if needed
	$fourthdisksize = Fourth Disk if needed
	$fifthdisksize = Fifth disk if needed
	$diskformat = The disk storage format of the vm
	$memory = Amount of memory to give the vm
	$cpu = The # of sockets
	$cores = The # of cores
	$netname = The network label to assign to the vm
	$guestostype = The os of the vm
	$trueval="true"
	$falseval="false"
.INPUTS
    Not really required but tailor them to your environment
.OUTPUTS
    All logging goes to c:\adbuild.txt
.NOTES
  Version:        1.3
  Author:         Mark Quinn
  Creation Date:  7/29/2018
  Purpose/Change: Initial script development
  
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>
Param(
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$logfolder,
	
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$csvfile,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [System.IO.FileInfo]$logfolder
)

$logfolder = "c:\buildlog"
$errorlog = "c:\buildlog\error.log"
$csvfile = "d:\mq.csv"

#capture where the script is being run from
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

#If logfolder is specified the directory will be created
if ($logfolder){
  If(Test-Path $logfolder){
  }  else {
      New-Item -ItemType Directory -Path $logfolder
  }
}

#Load the powercli module
$error.clear()

if ((Get-Module -Name "VMware.PowerCLI")) 
{
   Write-Host "The Vmware Powercli Module is installed proceeding to additional checks"
} else {
   Write-Warning "Vmware Powercli Module is NOT installed (must be installed before importing)."
   Write-Warning "Sending you to the link on how to install the powercli module please wait"  
   Start-Process 'https://www.powershellgallery.com/packages/VMware.PowerCLI'
   Add-Content $logfolder\$errorlog "The Powercli module was not installed" 
   Break
}

Import-Module "VMware.PowerCLI" -ErrorAction SilentlyContinue
If($error)
{
	Write-Host 'Vmare Powercli Module is not loading'
	Add-Content $logfolder\$errorlog "The Powercli module won't import" 
	Break
} 
Else
{
	Write-Host 'Vmware Powercli Module has been loaded'
}

#Get-Module -ListAvailable VMware* | Import-Module | Out-Null
#ignore connection errors for invalid certifcate and opt out of customer program
#begin the main script
Set-Powercliconfiguration -invalidcertificateaction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Connect-VIServer vcprd1.quinn.local

#checking to make sure the input file exists
If (Test-Path $csvfile){
  # // File exists
}Else{
  # // File does not exist
  Write-host "The requested input file is not available exiting"
  Add-Content $logfolder\$errorlog "The requested input file is not available exiting" 
  Break
}

#Check the csv to make sure all data fields are valid
$csv = Import-Csv $csvfile
foreach($vm in $csv){
    if([string]::IsNullOrEmpty($vm.vmname) ){
		Write-Host "Hostname is missing from the csv file"
		Add-Content $logfolder\$errorlog "Hostname is missing from the csv file"
		Break
    }
	if([string]::IsNullOrEmpty($vm.vmhostname) ){
		Write-Host "Vm hostname is missing from the csv file"
		Add-Content $logfolder\$errorlog "Vm Hostname is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.datastore)){
		Write-Host "Datastore is missing from the csv file"
		Add-Content $logfolder\$errorlog "Datastore is missing from the csv file"
		Break
	}
    if([string]::IsNullOrEmpty($vm.firstdisksize)){
		Write-Host "Firstdisksize is missing from the csv file"
		Add-Content $logfolder\$errorlog "First Disk Size is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.seconddisksize)){
		Write-Host "Seconddisksize is missing from the csv file"
		Add-Content $logfolder\$errorlog "Second Disk Size is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.thirddisksize)){
		Write-Host "Thirddisksize is missing from the csv file"
		Add-Content $logfolder\$errorlog "Third Disk Size is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.fourthdisksize)){
		Write-Host "Fourthdisksize is missing from the csv file"
		Add-Content $logfolder\$errorlog "Fourth Disk Size is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.fifthdisksize)){
		Write-Host "fifthdisksize is missing from the csv file"
		Add-Content $logfolder\$errorlog "Fifth Disk Size is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.diskformat)){
		Write-Host "diskformat is missing from the csv file"
		Add-Content $logfolder\$errorlog "The vmware storage format is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.memory)){
		Write-Host "The amount of memory is missing from the csv file"
		Add-Content $logfolder\$errorlog "The amount of memory is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.cpu)){
		Write-Host "cpu count is missing from the csv file"
		Add-Content $logfolder\$errorlog "The cpu count is missing from the csv file"
		Break
    }
    if([string]::IsNullOrEmpty($vm.cores)){
		Write-Host "The amount of cores per cpu is missing from the csv file"
		Add-Content $logfolder\$errorlog "The amount of cores per cpu is missing from the csv file"	
		Break
    }
    if([string]::IsNullOrEmpty($vm.netname)){
		Write-Host "The network label is missing from the csv file"
		Add-Content $logfolder\$errorlog "The network label is missing from the csv file"			
		Break
    }
    if([string]::IsNullOrEmpty($vm.ostype)){
		Write-Host "The operating system type is missing from the csv file"
		Add-Content $logfolder\$errorlog "The network label is missing from the csv file"			
		Break
    }
    if([string]::IsNullOrEmpty($vm.location)){
		Write-Host "The vcenter Location is missing from the csv file"
		Add-Content $logfolder\$errorlog "The vcenter Location is missing from the csv file"			
		Break
    }
}

#checking csv for null values
Import-Csv $csvfile | ForEach-Object{
  If($_.Psobject.Properties.Value -contains ""){
     # There is a null here somewhere
	 Add-Content $logfolder\$errorlog "The csv file contains null values Exiting."
     Throw "Null encountered in csv file. Stopping"
  } else {
    # process as normal
	## —-Load CSV and Variables—-
	$getinfo = Import-Csv $csvfile
	$getinfo | % {
	$Vmname = $_.vmname
	$hostname = $_.vmhostname
	$datastore = $_.datastore
	$firstdisksize = $_.firstdisksize
	$seconddisksize = $_.seconddisksize
	$thirddisksize = $_.thirddisksize
	$fourthdisksize = $_.fourthdisksize
	$fifthdisksize = $_.fifthdisksize
	$diskformat = $_.diskformat
	$memory = $_.memory
	$cpu = $_.cpu
	$cores = $_.cores
	$netname = $_.netname
	$guestostype = $_.ostype
	$guestostype = $_.location
	#$datastoreiso = $_.datastoreiso
	}
  }
}

#example below for creating a new vm
#New-VM -Name test2003 -Template $template -Datastore $datastore -VMHost $VMHost -Location $Location -DiskStorageFormat $DiskStorageFormat -RunAsync
#put in the names for the build or use a text file
#$newVmList = "testvm"
$taskTab = @{}
foreach($vmname in $getinfo){
	$Time=Get-Date
	$Logfile = "$vmname.log"
	Add-Content $logfolder\$logfile "Beginning Deployment Script"
	Add-Content $logfolder\$logfile $Time
	#check for disk space from totals 
	$datastorefree = get-datastore | select-object FreespaceGB
	[int]$totaldisk = [int]$firstdisksize + [int]$seconddisksize + [int]$thirddisksize + [int]$fourthdisksize + [int]$fifthdisksize
	#Write-Host $totaldisk
	Add-Content $logfolder\$logfile "Beginning Disk Space Check"
	If ($totaldisk -ge [int]$datastorefree) {
		#Write-Host "The vm is too big"
		#Write-Host "Exiting script there must be an error in the input file"
		Add-Content $logfolder\$errorlog "The Requested Virtual Machine Size of Disks was too large"
		Break
  	}  Else 
	{
	  #'This number is  not 1'
	  #The vm in this case can then proceed to be built
      Add-Content $logfolder\$logfile "The vm has passed the diskspace check."
	  Add-Content $logfolder\$logfile "The total disk usage for this deployment is $totaldisk"
	  Add-Content $logfolder\$logfile "Beginning Main Deployment" 
	} 
	#This section actually begins the new deployment 
	#recording the vm parameters for loggging
	$a = New-VM -Name $vmname -Datastore $datastore -NumCPU $cpu -MemoryGB $memory -DiskGB $firstdisksize -NetworkName $networkname -CD -DiskStorageFormat $diskformat -GuestID $guestostype -VMHost $VMHost -Location $Location
	Try
	{
		Add-Content $logfolder\$logfile "Beginning Main Deployment" 
		Add-Content $logfolder\$logfile "Commandline Being run to deploy the vm" 
		Add-Content $logfolder\$logfile $a
		#begin the depoloyment 
		$taskTab[(New-VM -Name $vmname -Datastore $datastore -NumCPU $cpu -MemoryGB $memory -DiskGB $firstdisksize -NetworkName $networkname -CD -DiskStorageFormat $diskformat -GuestID $guestostype -VMHost $VMHost -Location $Location -RunAsync).Id] = $Name
		$runningTasks = $taskTab.Count
		while($runningTasks -gt 0){
			Get-Task | % {
				if($taskTab.ContainsKey($_.Id) -and $_.State -eq "Success"){
					#Get-VM $taskTab[$_.Id] | Start-VM
					#$taskTab.Remove($_.Id)
					#$runningTasks--
					$initialconfig = "True"
				}
				elseif($taskTab.ContainsKey($_.Id) -and $_.State -eq "Error"){
					#$taskTab.Remove($_.Id)
					#$runningTasks--
					$initialconfig = "False"
				}
			}
			Start-Sleep -Seconds 15
		}				
	}
	Catch
	{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName
		Add-Content $logfolder\$errorlog "The deployment failed the error message is" $ErrorMessage
		Add-Content $logfolder\$errorlog "The deployment failed the item that failed is" $FailedItem		
	    Break
	}
	Finally
	{
	    if($initialconfig -eq 'True')
	    {
	        Add-Content $logfolder\$logfile "The initial Deployment has completed now moving to reconfigure the virtual machine" 
	    }
	    else
	    {
			$Time=Get-Date
        	Add-Content $logfolder\$errorlog "Initial configuration failed" 		
			break
    	}	
	
	}
}
 
$runningTasks = $taskTab.Count
while($runningTasks -gt 0){
  Get-Task | % {
    if($taskTab.ContainsKey($_.Id) -and $_.State -eq "Completed"){ #this will change with vcenter to Success for esx the status is Completed
      #set the vcpu and memory
	  $vmName = $taskTab[$_.Id]
	  #Write-Host $Vmname
	  #adjust the memory here for the vm  
	  Try {
	  	$VM = Get-VM $vmName | Set-VM -MemoryGB $memory -NumCpu $cpucount –Confirm:$False 
	  }
	  catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Adjusting the memory failed the error message is " $ErrorMessage
		Add-Content $logfolder\$errorlog "Adjusting the memory failed the item that failed is is" $FailedItem	
		break
	  }
	  Finally{
	  	Add-Content $logfolder\$logfile "The memory has been adjusted to $memory" 	
	  	Add-Content $logfolder\$logfile "The Cpu count has been adjusted to $cpu" 	
	  	Add-Content $logfolder\$logfile "Continuing on with the Deployment" 	
	  }
	  Try{
	 	  #Change the cores count
		  $VM = Get-VM -Name $Vmname
		  $VMSpec = New-Object –Type VMware.Vim.VirtualMAchineConfigSpec –Property @{“NumCoresPerSocket” = $cores}
		  $VM.ExtensionData.ReconfigVM_Task($VMSpec) 
	  }
	  Catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Adjusting the cores per socket failed the error message is " $ErrorMessage
		Add-Content $logfolder\$errorlog "Adjusting the cores per socket failed the item that failed is is" $FailedItem		
		break
	  }
	  Finally{
	  	Add-Content $logfolder\$logfile "The core count of the vm has been adjusted to $cores" 		  
	  }

	  Try{
    	  #change the network card to vmxnet 3 
	  	  $VM = Get-VM $vmName | Set-NetworkAdapter -Type Vmxnet3 -StartConnected:$true -Confirm:$false
	  }
	  Catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Setting the network card to vmxnet3 failed the error message is " $ErrorMessage
		Add-Content $logfolder\$errorlog "Setting the network card to vmxnet3 failed the item that failed is is" $FailedItem	
		break	  
	  }
	  Finally {
	  	Add-Content $logfolder\$logfile "The the virtual machine network card has been set to vmxnet3" 		  
	  }

      Try{
  	  	#change the network label (the vswitch here)
	  	$VM = Get-Vm $vmname | Set-NetworkAdapter -NetworkName $netname
	  }
	  Catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Setting the network label failed the error message is " $ErrorMessage
		Add-Content $logfolder\$errorlog "Setting the network label failed the item that failed is is" $FailedItem	
		break	  
	  }
	  Finally{
	  		Add-Content $logfolder\$logfile "The Network Label has been set to $netname" 	
	  }
	  
	  #change the disk configuration here
	  Try{
		  #second hard drive
		  $VM = Get-VM $vmName | New-HardDisk -DiskGB $seconddisksize | New-ScsiController -Type Paravirtual 
		  #change the virtual device node to 2:0
		  $Changedisk2 = Get-HardDisk -VM $vmname -Name "Hard disk 2"
		  $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
		  $spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
		  $spec.deviceChange[0].operation = "edit"
		  $spec.deviceChange[0].device = $Changedisk2.ExtensionData
		  $spec.deviceChange[0].device.unitNumber = 1
	      $vmname.ExtensionData.ReconfigVM_Task($spec)
	  }
	  Catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Reconfiguring the second drive failed with this error" $ErrorMessage
		Add-Content $logfolder\$errorlog "Reconfiguring the second drive failed with this item" $FailedItem	
		break	  	  
	  }
	  Finally{
  	       if ($seconddisksize -ge 0){ 
	  	  	  Add-Content $logfolder\$logfile "The second disk if configured has been added correctly"
		   }
		   Else{
	  	  	  Add-Content $logfolder\$logfile "There was no second disk requested for this build"
		   }
	  }
	  
	  Try{
		  $VM = Get-VM $vmName | New-HardDisk -DiskGB $thirddisksize | New-ScsiController -Type Paravirtual	  	
		  #change the virtual device node to 3:0
		  $Changedisk3 = Get-HardDisk -VM $vmname -Name "Hard disk 3"
		  $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
		  $spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
		  $spec.deviceChange[0].operation = "edit"
		  $spec.deviceChange[0].device = $Changedisk3.ExtensionData
		  $spec.deviceChange[0].device.unitNumber = 1
	      $vmname.ExtensionData.ReconfigVM_Task($spec)
	  }
	  Catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Reconfiguring the third drive failed with this error" $ErrorMessage
		Add-Content $logfolder\$errorlog "Reconfiguring the third drive failed with this item" $FailedItem	
		break	  	  
	  }
	  Finally{
	       if ($thirddisksize -ge 0){ 
	  	  	  Add-Content $logfolder\$logfile "The third disk if configured has been added correctly"
		   }
		   Else{
	  	  	  Add-Content $logfolder\$logfile "There was no third disk requested for this build"
		   }
	  } 
  
	  #add the additional hard disks as required with vmware paravirtual controller
	  #third hard drive
	  
	  Try{
		  #fourth hard drive
		  $VM = Get-VM $vmName | New-HardDisk -DiskGB $fourthdisksize | New-ScsiController -Type Paravirtual
		  #change the virtual device node to 4:0
		  $Changedisk4 = Get-HardDisk -VM $vmname -Name "Hard disk 4"
		  $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
		  $spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
		  $spec.deviceChange[0].operation = "edit"
		  $spec.deviceChange[0].device = $Changedisk4.ExtensionData
		  $spec.deviceChange[0].device.unitNumber = 1
	      $vmname.ExtensionData.ReconfigVM_Task($spec)  
	  }
	  Catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Reconfiguring the fourth drive failed with this error" $ErrorMessage
		Add-Content $logfolder\$errorlog "Reconfiguring the fourth drive failed with this item" $FailedItem	
		break	  	  
	  }
	  Finally{
  	       if ($fourthdisksize -ge 0){ 
	  	  	  Add-Content $logfolder\$logfile "The fourth disk if configured has been added correctly"
		   }
		   Else{
	  	  	  Add-Content $logfolder\$logfile "There wasn't a fourth disk requested for this build"
		   }
	  }
  
	  Try{
		  #fifth hard drive
		  $VM = Get-VM $vmName | New-HardDisk -DiskGB $fifthdisksize | New-ScsiController -Type Paravirtual
		  #change the virtual device node to 4:1
		  $Changedisk5 = Get-HardDisk -VM $vmname -Name "Hard disk 5"
		  $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
		  $spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
		  $spec.deviceChange[0].operation = "edit"
		  $spec.deviceChange[0].device = $Changedisk5.ExtensionData
		  $spec.deviceChange[0].device.unitNumber = 2
	      $vmname.ExtensionData.ReconfigVM_Task($spec)
	  }
	  Catch{
		$ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName  
		Add-Content $logfolder\$errorlog "Reconfiguring the fifth drive failed with this error" $ErrorMessage
		Add-Content $logfolder\$errorlog "Reconfiguring the fifth drive failed with this item" $FailedItem	
		break	  	  
	  }
	  Finally{
   	       if ($fourthdisksize -ge 0){ 
	  	  	  Add-Content $logfolder\$logfile "The fifth disk if configured has been added correctly"
		   }
		   Else{
	  	  	  Add-Content $logfolder\$logfile "There wasn't a Fifth disk requested for this build"
		   }
	  }

	  Try{
	  	  #get the serial number of the vm to be written later to the log file or uploaded
		  $serial = Get-VMSerial -VirtualMachine $Vmname	  
	  }
	  Catch{
	  }
	  Finally{
	  	  Add-Content $logfolder\$logfile "Acquired Serial Number of the vm correctly"
  	  	  Add-Content $logfolder\$logfile "The serial number of the vm being deployed is " $serial   
	  }
	  
	  Try{
		  #set vmware tools to manual
		  $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec  
	      $vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo  
	      $vmConfigSpec.Tools.ToolsUpgradePolicy = "manual"  
		  Get-VM $vmname | Get-View | %{ $_.ReconfigVM($vmConfigSpec)}  
	  }
	  Catch{
		  $ErrorMessage = $_.Exception.Message
	      $FailedItem = $_.Exception.ItemName  
		  Add-Content $logfolder\$errorlog "Setting the vmware tools checkbox failed the error is" $ErrorMessage
		  Add-Content $logfolder\$errorlog "Setting the vmware tools checkbox failed the error is" $FailedItem	
		  break	  	
	  }
	  Finally{
 	  	  	  Add-Content $logfolder\$logfile "Successfully set the vmware tools checkbox to manual updates"

	  }
#variables for the vmware hardening guide	  
$trueval="true"
$falseval="false"  
	  #perform the vmware hardening on the shell of the vm
	  #vmware hardening current ruleset with minimal settings
		#Vcm Rulesets all others remarked out rule 1
		#set isolation.tools.copy.disable to true
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.tools.copy.disable).Value -ne $trueval) {
		    Try{
			     New-AdvancedSetting -Entity $vmname -Name "isolation.tools.copy.disable" -Value $trueval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  					
			}
			Finally{
			 	Add-Content $logfolder\$logfile "Successfully set isolation.tools.copy.disable to " $trueval
			}
		}

		#Vcm Rulesets all others remarked out rule 2
		#set isolation.tools.dnd.disable to false
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.tools.dnd.disable).Value -ne $trueval) {
		    Try{
			 	New-AdvancedSetting -Entity $vmname -Name "isolation.tools.dnd.disable" -Value $trueval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  	
			}
			Finally{
				Add-Content $logfolder\$logfile "Successfully set isolation.tools.dnd.disable to " $trueval
			}
		}

		#Vcm Rulesets all others remarked out rule 3
		#set isolation.tools.setGUIOptions.enable to false
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.tools.setGUIOptions.enable).Value -ne $falseval) {
		    Try{
			 	New-AdvancedSetting -Entity $vmname -Name "isolation.tools.setGUIOptions.enable" -Value $falseval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				Add-Content $logfolder\$logfile "Successfully set isolation.tools.setGUIOptions.enable to " $falseval
			}
		}

		#Vcm Rulesets all others remarked out rule 4
		#set isolation.tools.paste.disable false
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.tools.paste.disable).Value -ne $trueval) {
		    Try{
			 	New-AdvancedSetting -Entity $vmname -Name "isolation.tools.paste.disable" -Value $trueval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set isolation.tools.paste.disable to " $trueval
			}
		}

		#Vcm Rulesets all others remarked out rule 5
		#set isolation.tools.diskShrink.disable to true
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.tools.diskShrink.disable).Value -ne $trueval) {
		    Try{
			 	New-AdvancedSetting -Entity $vmname -Name "isolation.tools.diskShrink.disable" -Value $trueval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set isolation.tools.diskShrink.disable to " $trueval
			}
		}

		#Vcm Rulesets all others remarked out rule 6
		#set isolation.tools.diskWiper.disable to true
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.tools.diskWiper.disable).Value -ne $trueval) {
		    Try{
			 	New-AdvancedSetting -Entity $vmname -Name "isolation.tools.diskWiper.disable" -Value $trueval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
			 	Add-Content $logfolder\$logfile "Successfully set isolation.tools.diskWiper.disable to " $trueval
			}
		}

		#Vcm Rulesets all others remarked out rule 7
		#set RemoteDisplay.maxConnections to 1
		if ((Get-AdvancedSetting -Entity $vmname -Name RemoteDisplay.maxConnections).Value -ne 2) {
		    Try{
			 	New-AdvancedSetting -Entity $vmname -Name "RemoteDisplay.maxConnections" -Value 2 -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
	    		Add-Content $logfolder\$logfile "Successfully set RemoteDisplay.maxConnections to 2"
			}
		}

		#Vcm Rulesets all others remarked out rule 8
		#set log.keepOld to 10
		if ((Get-AdvancedSetting -Entity $vmname -Name log.keepOld).Value -ne 10) {
		    Try{
				 New-AdvancedSetting -Entity $vmname -Name "log.keepOld" -Value 10 -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set log.keepOld to 10"
			}
		}

		#Vcm Rulesets all others remarked out rule 9
		#set log.rotateSize to 100000
		if ((Get-AdvancedSetting -Entity $vmname -Name log.rotateSize).Value -ne 100000) {
		    Try{
				 New-AdvancedSetting -Entity $vmname -Name "log.rotateSize" -Value 100000 -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set log.rotateSize to 100000"
			}
		}

		#Vcm Rulesets all others remarked out rule 10
		#set tools.setInfo.sizeLimit to 1048576
		if ((Get-AdvancedSetting -Entity $vmname -Name tools.setInfo.sizeLimit).Value -ne 1048576) {
		    Try{
				 New-AdvancedSetting -Entity $vmname -Name "tools.setInfo.sizeLimit" -Value 1048576 -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set tools.setInfo.sizeLimit to 1048576"
			}
		}

		#Vcm Rulesets all others remarked out rule 11
		#set RemoteDisplay.vnc.enabled to FALSE
		if ((Get-AdvancedSetting -Entity $vmname -Name RemoteDisplay.vnc.enabled).Value  -ne $falseval) {
		    Try{
				 New-AdvancedSetting -Entity $vmname -Name "RemoteDisplay.vnc.enabled" -Value $falseval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set RemoteDisplay.vnc.enabled to " $falseval
			}
		}

		#Vcm Rulesets all others remarked out rule 12
		#set isolation.device.connectable.disable to true
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.device.connectable.disable).Value -ne $trueval) {
		    Try{
				 New-AdvancedSetting -Entity $vmname -Name "isolation.device.connectable.disable" -Value $trueval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set isolation.device.connectable.disable to " $trueval
			}
		}

		#Vcm Rulesets all others remarked out rule 13
		#set isolation.device.edit.disable to true
		if ((Get-AdvancedSetting -Entity $vmname -Name isolation.device.edit.disable).Value -ne $trueval) {
		    Try{
				 New-AdvancedSetting -Entity $vmname -Name "isolation.device.edit.disable" -Value $trueval -Confirm:$false -Force
			}
			Catch{
				$ErrorMessage = $_.Exception.Message
			    $FailedItem = $_.Exception.ItemName  
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $ErrorMessage
				Add-Content $logfolder\$errorlog "Setting the isolation.tools.copy.disable the error is" $FailedItem	
				break	  				
			}
			Finally{
				 Add-Content $logfolder\$logfile "Successfully set isolation.device.connectable.disable to " $trueval
			}
				
	   }
	  $Time = Get-Date
	  Add-Content $logfolder\$logfile "Vm deployment successfully completed"
	  Add-Content $logfolder\$logfile $time
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



#mounting the appropriate os install cdrom drive 
#Get-CDDrive $GuestVM | Set-CDDrive -IsoPath $datastoreiso -startconnected:$true -Confirm:$false

#Start-VM -VM $GuestVM
Disconnect-VIServer -Confirm:$False

#Os Vmware NAME			Operating System Description
#asianux3_64Guest		Asianux Server 3 (64 bit)  –  Since vSphere API 4.0
#asianux3Guest			Asianux Server 3  –  Since vSphere API 4.0
#asianux4_64Guest		Asianux Server 4 (64 bit)  –  Since vSphere API 4.0
#asianux4Guest			Asianux Server 4  –  Since vSphere API 4.0
#asianux5_64Guest		Asianux Server 5 (64 bit)  –  Since vSphere API 6.0
#asianux7_64Guest		Asianux Server 7 (64 bit)  –  Since vSphere API 6.5
#centos6_64Guest		CentOS 6 (64-bit)  –  Since vSphere API 6.5
#centos64Guest			CentOS 4/5 (64-bit)  –  Since vSphere API 4.1
#centos6Guest			CentOS 6  –  Since vSphere API 6.5
#centos7_64Guest		CentOS 7 (64-bit)  –  Since vSphere API 6.5
#centos7Guest			CentOS 7  –  Since vSphere API 6.5
#centosGuest			CentOS 4/5  –  Since vSphere API 4.1
#coreos64Guest			CoreOS Linux (64 bit)  –  Since vSphere API 6.0
#darwin10_64Guest		Mac OS 10.6 (64 bit)  –  Since vSphere API 5.0
#darwin10Guest			Mac OS 10.6  –  Since vSphere API 5.0
#darwin11_64Guest		Mac OS 10.7 (64 bit)  –  Since vSphere API 5.0
#darwin11Guest			Mac OS 10.7  –  Since vSphere API 5.0
#darwin12_64Guest		Mac OS 10.8 (64 bit)  –  Since vSphere API 5.5
#darwin13_64Guest		Mac OS 10.9 (64 bit)  –  Since vSphere API 5.5
#darwin14_64Guest		Mac OS 10.10 (64 bit)  –  Since vSphere API 6.0
#darwin15_64Guest		Mac OS 10.11 (64 bit)  –  Since vSphere API 6.5
#darwin16_64Guest		Mac OS 10.12 (64 bit)  –  Since vSphere API 6.5
#darwin64Guest			Mac OS 10.5 (64 bit)  –  Since vSphere API 4.0
#darwinGuest			Mac OS 10.5
#debian10_64Guest		Debian GNU/Linux 10 (64 bit)  –  Since vSphere API 6.5
#debian10Guest			Debian GNU/Linux 10  –  Since vSphere API 6.5
#debian4_64Guest		Debian GNU/Linux 4 (64 bit)  –  Since vSphere API 4.0
#debian4Guest			Debian GNU/Linux 4  –  Since vSphere API 4.0
#debian5_64Guest		Debian GNU/Linux 5 (64 bit)  –  Since vSphere API 4.0
#debian5Guest			Debian GNU/Linux 5  –  Since vSphere API 4.0
#debian6_64Guest		Debian GNU/Linux 6 (64 bit)  –  Since vSphere API 5.0
#debian6Guest			Debian GNU/Linux 6  –  Since vSphere API 5.0
#debian7_64Guest		Debian GNU/Linux 7 (64 bit)  –  Since vSphere API 5.5
#debian7Guest			Debian GNU/Linux 7  –  Since vSphere API 5.5
#debian8_64Guest		Debian GNU/Linux 8 (64 bit)  –  Since vSphere API 6.0
#debian8Guest			Debian GNU/Linux 8  –  Since vSphere API 6.0
#debian9_64Guest		sDebian GNU/Linux 9 (64 bit)  –  Since vSphere API 6.5
#debian9Guest			Debian GNU/Linux 9  –  Since vSphere API 6.5
#dosGuest				MS-DOS.
#eComStation2Guest		eComStation 2.0  –  Since vSphere API 5.0
#eComStationGuest		eComStation 1.x  –  Since vSphere API 4.1
#fedora64Guest			Fedora Linux (64 bit)  –  Since vSphere API 5.1
#fedoraGuest			Fedora Linux  –  Since vSphere API 5.1
#freebsd64Guest			FreeBSD x64
#freebsdGuest			FreeBSD
#genericLinuxGuest		Other Linux  –  Since vSphere API 5.5
#mandrakeGuest			Mandrake Linux  –  Since vSphere API 5.5
#mandriva64Guest		Mandriva Linux (64 bit)  –  Since vSphere API 4.0
#mandrivaGuest			Mandriva Linux  –  Since vSphere API 4.0
#netware4Guest			Novell NetWare 4
#netware5Guest			Novell NetWare 5.1
#netware6Guest			Novell NetWare 6.x
#nld9Guest				Novell Linux Desktop 9
#oesGuest				Open Enterprise Server
#openServer5Guest		SCO OpenServer 5  –  Since vSphere API 4.0
#openServer6Guest		SCO OpenServer 6  –  Since vSphere API 4.0
#opensuse64Guest		OpenSUSE Linux (64 bit)  –  Since vSphere API 5.1
#opensuseGuest			OpenSUSE Linux  –  Since vSphere API 5.1
#oracleLinux6_64Guest	Oracle 6 (64-bit)  –  Since vSphere API 6.5
#oracleLinux64Guest		Oracle Linux 4/5 (64-bit)  –  Since vSphere API 4.1
#oracleLinux6Guest		Oracle 6  –  Since vSphere API 6.5
#oracleLinux7_64Guest	Oracle 7 (64-bit)  –  Since vSphere API 6.5
#oracleLinux7Guest		Oracle 7  –  Since vSphere API 6.5
#oracleLinuxGuest		Oracle Linux 4/5  –  Since vSphere API 4.1
#os2Guest				OS/2
#other24xLinux64Guest	Linux 2.4x Kernel (64 bit) (experimental)
#other24xLinuxGuest		Linux 2.4x Kernel
#other26xLinux64Guest	Linux 2.6x Kernel (64 bit) (experimental)
#other26xLinuxGuest		Linux 2.6x Kernel
#other3xLinux64Guest	Linux 3.x Kernel (64 bit)  –  Since vSphere API 5.5
#other3xLinuxGuest		Linux 3.x Kernel  –  Since vSphere API 5.5
#otherGuest				Other Operating System
#otherGuest64			Other Operating System (64 bit) (experimental)
#otherLinux64Guest		Linux (64 bit) (experimental)
#otherLinuxGuest		Linux 2.2x Kernel
#redhatGuest			Red Hat Linux 2.1
#rhel2Guest				Red Hat Enterprise Linux 2
#rhel3_64Guest			Red Hat Enterprise Linux 3 (64 bit)
#rhel3Guest				Red Hat Enterprise Linux 3
#rhel4_64Guest			Red Hat Enterprise Linux 4 (64 bit)
#rhel4Guest				Red Hat Enterprise Linux 4
#rhel5_64Guest			Red Hat Enterprise Linux 5 (64 bit) (experimental)  –  Since VI API 2.5
#rhel5Guest	Red 		Hat Enterprise Linux 5  –  Since VI API 2.5
#rhel6_64Guest			Red Hat Enterprise Linux 6 (64 bit)  –  Since vSphere API 4.0
#rhel6Guest	Red 		Hat Enterprise Linux 6  –  Since vSphere API 4.0
#rhel7_64Guest			Red Hat Enterprise Linux 7 (64 bit)  –  Since vSphere API 5.5
#rhel7Guest	Red 		Hat Enterprise Linux 7  –  Since vSphere API 5.5
#sjdsGuest	Sun 		Java Desktop System
#sles10_64Guest			Suse Linux Enterprise Server 10 (64 bit) (experimental)  –  Since VI API 2.5
#sles10Guest			Suse linux Enterprise Server 10  –  Since VI API 2.5
#sles11_64Guest			Suse Linux Enterprise Server 11 (64 bit)  –  Since vSphere API 4.0
#sles11Guest			Suse linux Enterprise Server 11  –  Since vSphere API 4.0
#sles12_64Guest			Suse Linux Enterprise Server 12 (64 bit)  –  Since vSphere API 5.5
#sles12Guest			Suse linux Enterprise Server 12  –  Since vSphere API 5.5
#sles64Guest			Suse Linux Enterprise Server 9 (64 bit)
#slesGuest				Suse Linux Enterprise Server 9
#solaris10_64Guest		Solaris 10 (64 bit) (experimental)
#solaris10Guest			Solaris 10 (32 bit) (experimental)
#solaris11_64Guest		Solaris 11 (64 bit)Since vSphere API 5.0
#solaris6Guest			Solaris 6
#solaris7Guest			Solaris 7
#solaris8Guest			Solaris 8
#solaris9Guest			Solaris 9
#suse64Guest			Suse Linux (64 bit)
#suseGuest				Suse Linux
#turboLinux64Guest		Turbolinux (64 bit)  –  Since vSphere API 4.0
#turboLinuxGuest		Turbolinux
#ubuntu64Guest			Ubuntu Linux (64 bit)
#ubuntuGuest			Ubuntu Linux
#unixWare7Guest			SCO UnixWare 7  –  Since vSphere API 4.0
#vmkernel5Guest			VMware ESX 5  –  Since vSphere API 5.0
#vmkernel65Guest		VMware ESX 6.5  –  Since vSphere API 6.5
#vmkernel6Guest			VMware ESX 6  –  Since vSphere API 6.0
#vmkernelGuest			VMware ESX 4  –  Since vSphere API 5.0
#vmwarePhoton64Guest	VMware Photon (64 bit)  –  Since vSphere API 6.5
#win2000AdvServGuest	Windows 2000 Advanced Server
#win2000ProGuest		Windows 2000 Professional
#win2000ServGuest		Windows 2000 Server
#win31Guest				Windows 3.1
#win95Guest				Windows 95
#win98Guest				Windows 98
#windows7_64Guest		Windows 7 (64 bit)  –  Since vSphere API 4.0
#windows7Guest			Windows 7  –  Since vSphere API 4.0
#windows7Server64Guest	Windows Server 2008 R2 (64 bit)  –  Since vSphere API 4.0
#windows8_64Guest		Windows 8 (64 bit)  –  Since vSphere API 5.0
#windows8Guest			Windows 8  –  Since vSphere API 5.0
#windows8Server64Guest	Windows 8 Server (64 bit)  –  Since vSphere API 5.0
#windows9_64Guest		Windows 10 (64 bit)  –  Since vSphere API 6.0
#windows9Guest			Windows 10  –  Since vSphere API 6.0
#windows9Server64Guest	Windows 10 Server (64 bit)  –  Since vSphere API 6.0
#windowsHyperVGuest		Windows Hyper-V  –  Since vSphere API 5.5
#winLonghorn64Guest		Windows Longhorn (64 bit) (experimental)  –  Since VI API 2.5
#winLonghornGuest		Windows Longhorn (experimental)  –  Since VI API 2.5
#winMeGuest				Windows Millenium Edition
#winNetBusinessGuest	Windows Small Business Server 2003
#winNetDatacenter64Guest	Windows Server 2003, Datacenter Edition (64 bit) (experimental)  –Since VI API 2.5
#winNetDatacenterGuest	Windows Server 2003, Datacenter Edition  –  Since VI API 2.5
#winNetEnterprise64Guest	Windows Server 2003, Enterprise Edition (64 bit)
#winNetEnterpriseGuest	Windows Server 2003, Enterprise Edition
#winNetStandard64Guest	Windows Server 2003, Standard Edition (64 bit)
#winNetStandardGuest	Windows Server 2003, Standard Edition
#winNetWebGuest			Windows Server 2003, Web Edition
#winNTGuest				Windows NT 4
#winVista64Guest		Windows Vista (64 bit)
#winVistaGuest			Windows Vista
#winXPHomeGuest			Windows XP Home Edition
#winXPPro64Guest		Windows XP Professional Edition (64 bit)
#winXPProGuest			Windows XP Professional

#functions begin here
Function Check-PowerCLIUpdate {
    #Based on great module by Jeff Hicks here: http://jdhitsolutions.com/blog/powershell/5441/check-for-module-updates/
    [cmdletbinding()]
    Param()
 
    # Getting installed modules
    $modules = Get-Module -ListAvailable VMware* | Sort-Object Version -Descending | Select-object -Unique
 
    #Filter to modules from the PSGallery
    $gallery = $modules.where({$_.repositorysourcelocation})
 
    # Comparing to online versions
    $AllUpdatedModules = @()
    foreach ($module in $gallery) {
 
         #find the current version in the gallery
         Try {
            $online = Find-Module -Name $module.name -Repository PSGallery -ErrorAction Stop
         }
         Catch {
            Write-Warning "Module $($module.name) was not found in the PSGallery and therefore not checked for an update"
         }
 
         #compare versions
         if ($online.version -gt $module.version) {
            $AllUpdatedModules += new-object PSObject -Property @{
                Name = $module.name
                InstalledVersion = $module.version
                OnlineVersion = $online.version
                Update = $True
                Path = $module.modulebase
             } 
         }
    }
    $AllUpdatedModules | Format-Table
    #Check completed
 
}

function Get-VMSerial
{
	param([VMware.VimAutomation.ViCore.Impl.V1.Inventory.VirtualMachineImpl]$VirtualMachine)

	$s = ($VirtualMachine.ExtensionData.Config.Uuid).Replace("-", "")
	$Uuid = "VMware-"
	for ($i = 0; $i -lt $s.Length; $i += 2)
	{
		$Uuid += ("{0:x2}" -f [byte]("0x" + $s.Substring($i, 2)))
		if ($Uuid.Length -eq 30) { $Uuid += "-" } else { $Uuid += " " }
	}

	Write-Output $Uuid.TrimEnd()
}