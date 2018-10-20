#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to create a windows cluster
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
    List all parameters here
    $name (name of the cluster)
    $node1 (first node of the cluster)
    $node2 (second node of the cluster)
    $ou (ou for the cluster)
    $staticaddress (static address of the cluster vip)
    $IgnoreNetwork
    $AdministrativeAccessPoint
    $errorlog
    $logfile
    $logfolder
.INPUTS
    List all inputs here
    $name (name of the cluster)
    $node1 (first node of the cluster)
    $node2 (second node of the cluster)
    $ou (ou for the cluster)
    $staticaddress (static address of the cluster vip)
    $IgnoreNetwork
    $AdministrativeAccessPoint
    $errorlog - the log that gets created on a trapped error
    $logfile - the log of the action and completion
    $logfolder - where the logs get created
.OUTPUTS
    Logging will output when enabled    
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article
  https://docs.microsoft.com/en-us/powershell/module/failoverclusters/new-cluster?view=win10-ps
  You must have the following rights to use the script Create Computer Objects and Read All Properties in the ou the server resides in.
  
.EXAMPLE
  Example 1
  This example creates a four-node cluster named cluster1, using default settings for IP addressing.
  New-Cluster -Name cluster1 -Node node1,node2,node3,node4
  Example 2
  This example creates a two-node cluster named cluster1. 
  The cluster will not have any clustered storage, or disk resources. Storage can be added using the Get-ClusterAvailableDisk cmdlet with the Add-ClusterDisk cmdlet.
  New-Cluster -Name cluster1 -Node node1,node2 -NoStorage
  Example 3
  This example creates a four-node cluster named cluster1 that uses the static IP address 2.0.0.123.
  New-Cluster -Name cluster1 -Node node1,node2,node3,node4 -StaticAddress 2.0.0.123
  Example 4
  This example creates a four-node cluster named cluster1 that uses the static IP addresses 2.0.0.123 and 3.0.0.123.
  New-Cluster -Name cluster1 -Node node1,node2,node3,node4 -StaticAddress 2.0.0.123,3.0.0.123
  Example 5
  This example creates a four-node cluster named cluster1. The cluster uses default settings for IP addressing, and does not use the network 2.0.0.0/8.
  New-Cluster -Name cluster1 -Node node1,node2,node3,node4 -IgnoreNetwork 2.0.0.0/8
  Example 6
  This example creates a four-node cluster named cluster1. The cluster uses the static IP address 2.0.0.123, and does not use the network 3.0.0.0/8.
  New-Cluster -Name cluster1 -Node node1,node2,node3,node4 -StaticAddress 2.0.0.123 -IgnoreNetwork 3.0.0.0/8
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$true)]
  [string]$name,
	
  [Parameter(Mandatory=$False)]
  [string]$node1,

  [Parameter(Mandatory=$False)]
  [string]$node2,

  [Parameter(Mandatory=$False)]
  [string]$staticaddress,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [string]$logfolder
)

Try {
  Import-module servermanager
 }
 
 Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
    Break
 }
 
 Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
}


 Try {
  Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools
 }
 
 Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
  Break
 }
 
 Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
 }

 Try {
  New-Cluster -Name $clustername -Node  $node1, $node2 -StaticAddress $staticaddress
  #for example
  #New-Cluster -Name "CN=WINCLUSTER3,OU=Clusters,DC=TESTDOMAIN,DC=local" -Node WS-CLUSTER3,WS-CLUSTER4 -StaticAddress 172.16.0.193 
 }
 
 Catch {
  $myerror = $_.Exception 
  $errorMessage = $_.Exception.Message
  $FailedItem = $_.Exception.ItemName 

  if (!$logfolder -and $errorlog)
  {
    Write-Host "No Error log folder specified logging will be created in the directory where the script is run from"
    Add-Content $scriptdir\$errorlog "The error is " $myError
    Add-Content $scriptdir\$errorlog "The error message is " $ErrorMessage
    Add-Content $scriptdir\$errorlog "The item that failed is " $FailedItem        
  } elseif ($logfolder -and $errorlog) 
  {
    Add-Content $logfolder\$errorlog "The error is " $myError
    Add-Content $logfolder\$errorlog "The error message is " $ErrorMessage
    Add-Content $logfolder\$errorlog "The item that failed is " $FailedItem        
  }
  elseif ([string]::IsNullOrWhiteSpace($Errorlog)) 
  {
    write-host "No error log specified outputting errors to the screen " 
    Write-host "The exception that occured is " $myerror
    Write-host "The error message is " $errormessage
    Write-host "The item that fialed is " $faileditem
  }
    Break
 }
 
 Finally {
  if (!$logfolder -and $logfile) 
  {
    #Write-host "No logfolder specified logs will be created locally if requested"   	
    Add-Content $ScriptDir\$logfile "The action completed succesfully."   
  }
  elseif ($logfolder -and $logfile)
  {
    Add-Content $logfolder\$logfile "The action completed succesfully."   
  }
  elseif ([string]::IsNullOrWhiteSpace($logfile)) 
  {
    #Write-host "logfile not specified"
    write-host "The command completed successfully"   
  }
 }


 