#check if uac is enabled
$uac = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA
#Write-Host $uac

If ($uac -eq 1) {
	Write-Host "Uac is enabled"
	#check the uac level of the system
	$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 
	$ConsentPromptBehaviorAdmin_Name = "ConsentPromptBehaviorAdmin" 
	$PromptOnSecureDesktop_Name = "PromptOnSecureDesktop" 
	$ConsentPromptBehaviorAdmin_Value = Get-RegistryValue $Key $ConsentPromptBehaviorAdmin_Name 
	$PromptOnSecureDesktop_Value = Get-RegistryValue $Key $PromptOnSecureDesktop_Name 
	#for reference
	#ConsentPromptBehaviorAdmin
	#0x00000000
	#This option allows the Consent Admin to perform an operation that requires elevation without consent or credentials.
	#0x00000001
	#This option prompts the Consent Admin to enter his or her user name and password (or another valid admin) when an operation requires elevation of privilege. This operation occurs on the secure desktop.
	#0x00000002
	#This option prompts the administrator in Admin Approval Mode to select either "Permit" or "Deny" an operation that requires elevation of privilege. If the Consent Admin selects Permit, the operation will continue with the highest available privilege. "Prompt for consent" removes the inconvenience of requiring that users enter their name and password to perform a privileged task. This operation occurs on the secure desktop.
	#0x00000003
	#This option prompts the Consent Admin to enter his or her user name and password (or that of another valid admin) when an operation requires elevation of privilege.
	#0x00000004
	#This prompts the administrator in Admin Approval Mode to select either "Permit" or "Deny" an operation that requires elevation of privilege. If the Consent Admin selects Permit, the operation will continue with the highest available privilege. "Prompt for consent" removes the inconvenience of requiring that users enter their name and password to perform a privileged task.
	#0x00000005
	#This option is the default. It is used to prompt the administrator in Admin Approval Mode to select either "Permit" or "Deny" for an operation that requires elevation of privilege for any non-Windows binaries. If the Consent Admin selects Permit, the operation will continue with the highest available privilege. This operation will happen on the secure desktop. Windows binaries will be allowed to perform an operation that requires elevation without consent or credentials.

	#PromptOnSecureDesktop
	#0x00000000
	#Disabling this policy disables secure desktop prompting. All credential or consent prompting will occur on the interactive user's desktop.
	#0x00000001
	#This policy will force all UAC prompts to happen on the user's secure desktop.

	#Write-Host $ConsentPromptBehaviorAdmin_Name
	#Write-Host $PromptOnSecureDesktop_Name
  }  Else {
  	Write-Host "Uac is not enabled"
} 

