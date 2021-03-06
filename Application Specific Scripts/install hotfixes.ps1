<#
.SYNOPSIS
  This script can be used to install multiple kb articles
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
  
.EXAMPLE
  Copy the file to the host and begin the Configuration
#>
$source = "c:\temp" #Source folder
$KBArrayList = New-Object -TypeName System.Collections.ArrayList
$KBArrayList.AddRange(@("KB2775511""KB2533623","KB2639308","KB2670838","KB2729094","KB2731771","KB2786081","KB2834140","KB2882822","KB2888049",""))
 
foreach ($KB in $KBArrayList) {
	if (-not(Get-Hotfix -Id $KB)) {
	Start-Process -FilePath "wusa.exe" -ArgumentList "$source\$KB.msu /quiet /norestart" -Wait
	}
}