#requires -version 5.1
<#
.SYNOPSIS
  This script can be used to configure explorer options
.DESCRIPTION
  
.PARAMETER <Parameter_Name>
  List all parameters here
  $Start_SearchFiles        - Don't slow down search by including all public folders     
  $StartMenuAdminTools      - Show Administrative tools      
  $ServerAdminUI            - if applied to the default profile in windows 7, the value 2 suppresses inclusion of the links from "UserAssist" (detailed explanation here) in the StartMenu and Taskbar for subsequently created profiles.    
  $Hidden                   - Show hidden files and folders     
  $ShowCompColor               
  $HideFileExt              - Hide File extensions of known filetypes           
  $DontPrettyPath           - Display correct file name capitalization         
  $ShowInfoTip              - Disable info tips of icons on Desktop and Windows Explorer     
  $HideIcons                - Hide desktop icons         
  $MapNetDrvBtn                
  $WebView                  - Use Web view for folders         
  $Filter                      
  $SuperHidden              - Display hidden files and folders          
  $SeparateProcess          - Launch File Explorer in separate processes
  $NoNetCrawling            - Prevent automatically locate file shares and printers             
  $AutoCheckSelect          - Enable Check Boxes in File Explorer in Windows 10     
  $IconsOnly                - Don't show thumbnails    
  $ShowTypeOverlay          - Display file icon on thumbnails     
  $ListviewAlphaSelect         
  $ListviewShadow              
  $TaskbarAnimations           
  $StartMenuInit               
  $Start_ShowMyGames           
  $NavPaneShowAllFolders       
  $NavPaneExpandToCurrentFolder
  $AlwaysShowMenus               - Always show File Explorer menues   
  $HideDrivesWithNoMedia         - Hide empty drives   
  $ShowSuperHidden               - Show system files and folders   
  $TaskbarSizeMove               - Unlocked Taskbar   
  $DisablePreviewDesktop       
  $TaskbarSmallIcons             - Small Taskbar icons    
  $TaskbarGlomLevel            
  $Start_PowerButtonAction     
  $StartMenuFavorites          
  $Start_ShowNetPlaces         
  $Start_ShowRecentDocs        
  $Start_ShowRun               
  $Start_MinMFU                
  $Start_JumpListItems         
  $Start_AdminToolsRoot        
  $ShowStatusBar                  - Show status bar  
  $StoreAppsOnTaskbar          
  $EnableStartMenu             
  $ReindexedProfile            
  $DontUsePowerShellOnWinX   
  $FolderContentsInfoTip          - Display file size information in folder tips
  $HideMergeConflicts             - HideMergeConflicts
  $PersistBrowsers                - Don't restore folder windows at logon
  $ShowEncryptCompressedColor     - Show encrypted and/or compressed files in color
  $ShowPreviewHandlers            - Show preview handlers in preview pane
  $ShowSyncProviderNotifications  - Don't show sync provider notifications
  $SharingWizardOn                - Use the sharing wizard
  $errorlog
  $logfile
  $logfolder
.INPUTS
  List all inputs here
  $Start_SearchFiles           
  $StartMenuAdminTools         
  $ServerAdminUI               
  $Hidden                      
  $ShowCompColor               
  $HideFileExt                 
  $DontPrettyPath              
  $ShowInfoTip                 
  $HideIcons                   
  $MapNetDrvBtn                
  $WebView                     
  $Filter                      
  $SuperHidden                 
  $SeparateProcess 
  $NoNetCrawling            
  $AutoCheckSelect             
  $IconsOnly                   
  $ShowTypeOverlay             
  $ListviewAlphaSelect         
  $ListviewShadow              
  $TaskbarAnimations           
  $StartMenuInit               
  $Start_ShowMyGames           
  $NavPaneShowAllFolders       
  $NavPaneExpandToCurrentFolder
  $AlwaysShowMenus             
  $HideDrivesWithNoMedia       
  $ShowSuperHidden             
  $TaskbarSizeMove             
  $DisablePreviewDesktop       
  $TaskbarSmallIcons           
  $TaskbarGlomLevel            
  $Start_PowerButtonAction     
  $StartMenuFavorites          
  $Start_ShowNetPlaces         
  $Start_ShowRecentDocs        
  $Start_ShowRun               
  $Start_MinMFU                
  $Start_JumpListItems         
  $Start_AdminToolsRoot        
  $ShowStatusBar               
  $StoreAppsOnTaskbar          
  $EnableStartMenu             
  $ReindexedProfile            
  $DontUsePowerShellOnWinX     
  $FolderContentsInfoTip      
  $HideMergeConflicts
  $PersistBrowsers
  $SharingWizardOn
  $errorlog - the log that gets created on a trapped error
  $logfile - the log of the action and completion
  $logfolder - where the logs get created
.OUTPUTS
   Standard logfiles if enabled
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  9/30/2018
  Purpose/Change: Initial script development
  Based on this article 
.EXAMPLE
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
#>

Param(
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$parameter1,
	
  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$parameter2,

  [Parameter(Mandatory=$False)]
  [ValidateNotNull()]
  [string]$parameter3,

  [Parameter(Mandatory=$False)]
  [string]$errorlog,

  [Parameter(Mandatory=$False)]
  [string]$logfile,

  [Parameter(Mandatory=$False)]
  [System.IO.FileInfo]$logfolder
)

#capture where the script is being run from
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

#If logfolder is specified the directory will be created
if ($logfolder){
  If(Test-Path $logfolder){
  }  else {
      New-Item -ItemType Directory -Path $logfolder
  }
}

Try {
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

