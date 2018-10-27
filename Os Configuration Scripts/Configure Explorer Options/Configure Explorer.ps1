<#
.SYNOPSIS
  This script can be used to configure explorer options
.DESCRIPTION
  The script can be used to configure all of the known explorer options available for custiomizing the interface of windows explorer and the start bar options as well.

  The options available below are the known registry entries that can be enabled.

  Be careful and test how you want your interface to look and then used the parameters to customize

  All settings are part of a hashtable where the options are remarked out.
  
.PARAMETER <Parameter_Name>
  List all parameters here
  $Start_SearchFiles             - Don't slow down search by including all public folders     
  $StartMenuAdminTools           - Show Administrative tools      
  $ServerAdminUI                 - if applied to the default profile in windows 7, the value 2 suppresses inclusion of the links from "UserAssist" (detailed explanation here) in the StartMenu and Taskbar for subsequently created profiles.    
  $Hidden                        - Show hidden files and folders     
  $ShowCompColor                 - Show compressed files in an alternate color.
  $HideFileExt                   - Hide File extensions of known filetypes           
  $DontPrettyPath                - Display correct file name capitalization         
  $ShowInfoTip                   - Disable info tips of icons on Desktop and Windows Explorer     
  $HideIcons                     - Hide desktop icons         
  $MapNetDrvBtn                  - Show the Map Nework Drive button.
  $WebView                       - Use Web view for folders         
  $Filter                      
  $SuperHidden                    - Display hidden files and folders          
  $SeparateProcess                - Launch File Explorer in separate processes
  $NoNetCrawling                  - Prevent automatically locate file shares and printers             
  $AutoCheckSelect                - Enable Check Boxes in File Explorer in Windows 10     
  $IconsOnly                      - Don't show thumbnails    
  $ShowTypeOverlay                - Display file icon on thumbnails     
  $ListviewAlphaSelect            - Disable “Show translucent selection rectangle”
  $ListviewShadow                 - Enable Transparent Icons
  $TaskbarAnimations              - Turn on / off taskbar animations
  $StartMenuInit                  - StartMenuInit is responsible for adding the Edge icon to the taskbar
  $Start_ShowMyGames              - Hide My Games from the Start Menu
  $NavPaneShowAllFolders          - Show all folders in Windows
  $NavPaneExpandToCurrentFolder   - Navigation Pane Expand to Open Folder 
  $AlwaysShowMenus                - Always show File Explorer menues   
  $HideDrivesWithNoMedia          - Hide empty drives   
  $ShowSuperHidden                - Show system files and folders   
  $TaskbarSizeMove                - Unlocked Taskbar   
  $DisablePreviewDesktop          - Turn On or Off Peek at Desktop
  $TaskbarSmallIcons              - Small Taskbar icons    
  $TaskbarGlomLevel               - How taskbar icons are grouped (possible values 0,1,2)
  $Start_PowerButtonAction        - Set Default Action for Shutdown Dialog
  $StartMenuFavorites             - Display the Favorites menu item from the Start menu.
  $Start_ShowNetPlaces            - Add My Network Places to Start Menu
  $Start_ShowRecentDocs           - Remove cascading effect of My Recent Documents items in the new Start menu.
  $Start_ShowRun                  - Show Run command on Start menu.
  $Start_MinMFU                   - Change the Number of Recent Programs to Display in Windows Start Menu
  $Start_JumpListItems            - To change (increase or decrease) the number of recent items displayed in Windows Jump List
  $Start_AdminToolsRoot           - Administrative Tools - Add or Remove from Start Menu
  $ShowStatusBar                  - Show status bar  
  $StoreAppsOnTaskbar             - Show Windows Store Apps On Taskbar
  $EnableStartMenu                - specifies whether the Start menu is enabled and users can click on it.
  $ReindexedProfile            
  $DontUsePowerShellOnWinX        - Change Command Prompt to PowerShell as Default in WinX Menu Action
  $FolderContentsInfoTip          - Display file size information in folder tips
  $HideMergeConflicts             - HideMergeConflicts
  $PersistBrowsers                - Don't restore folder windows at logon
  $ShowEncryptCompressedColor     - Show encrypted and/or compressed files in color
  $ShowPreviewHandlers            - Show preview handlers in preview pane
  $ShowSyncProviderNotifications  - Don't show sync provider notifications
  $SharingWizardOn                - Use the sharing wizard
  $ShowSecondsInSystemClock       - Show seconds on the system clock
  $errorlog
  $logfile
  $logfolder

.INPUTS
  List all inputs here
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
 
.EXAMPLE
  To add error logging add the following parameters from below
  -errorlog (logfilename) -logfile (logfilename) -logfolder (path to the log files)
.LINK
  Based on this article 
  https://blogs.technet.microsoft.com/heyscriptingguy/2009/01/06/hey-scripting-guy-how-can-i-modify-registry-settings-that-configure-windows-explorer/
#>

Param(
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

#building the hashtable with all desired settings you have to unremark the options that you want.
# see explenations above for what each setting does.

$exploreropt = @{
    #"Start_SearchFiles" = "1" ;
    #"StartMenuAdminTools" = "1" ;        
    #"ServerAdminUI" = "1" ;              
    #"Hidden" = "1" ;                     
    #"ShowCompColor" = "1" ;               
    #"HideFileExt" = "1" ;                
    #"DontPrettyPath" = "1" ;             
    #"ShowInfoTip" = "1" ;                
    #"HideIcons" = "1" ;                  
    #"MapNetDrvBtn" = "1" ;              
    #"WebView" = "1" ;                   
    #"Filter" = "1" ;                    
    #"SuperHidden" = "1" ;               
    #"SeparateProcess" = "1" ;
    #"NoNetCrawling" = "1" ;           
    #"AutoCheckSelect" = "1" ;           
    #"IconsOnly" = "1" ;                  
    #"ShowTypeOverlay" = "1" ;             
    #"ListviewAlphaSelect" = "1" ;        
    #"ListviewShadow" = "1" ;             
    #"TaskbarAnimations" = "1" ;          
    #"StartMenuInit" = "1" ;              
    #"Start_ShowMyGames" = "1" ;         
    #"NavPaneShowAllFolders" = "1" ;     
    #"NavPaneExpandToCurrentFolder" = "1" ;
    #"AlwaysShowMenus"  = "1" ;           
    #"HideDrivesWithNoMedia"  = "1" ;      
    #"ShowSuperHidden" = "1" ;            
    #"TaskbarSizeMove" = "1" ;            
    #"DisablePreviewDesktop" = "1" ;       
    #"TaskbarSmallIcons" = "1" ;          
    #"TaskbarGlomLevel"  = "1" ;          
    #"Start_PowerButtonAction" = "1" ;     
    #"StartMenuFavorites" = "1" ;         
    #"Start_ShowNetPlaces" = "1" ;       
    #"Start_ShowRecentDocs" = "1" ;       
    #"Start_ShowRun" = "1" ;              
    #"Start_MinMFU" = "1" ;               
    #"Start_JumpListItems" = "1" ;        
    #"Start_AdminToolsRoot" = "1" ;       
    #"ShowStatusBar" = "1" ;              
    #"StoreAppsOnTaskbar" = "1" ;         
    #"EnableStartMenu" = "1" ;            
    #"ReindexedProfile" = "1" ;           
    #"DontUsePowerShellOnWinX" = "1" ;    
    #"FolderContentsInfoTip" = "1" ;     
    #"HideMergeConflicts" = "1" ; 
    #"PersistBrowsers" = "1" ;
    #"SharingWizardOn" = "1" ;
    #"ShowSecondsInSystemClock" = "1" 
}

$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

ForEach ($key in $exploreropt.Keys)
  {
    Set-ItemProperty -path $path -name $key -value $exploreropt[$key]
   "Setting $path $($key) to $($exploreropt[$key])"
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

#restartigng explorer for changes to take effect
Stop-Process -processName: Explorer