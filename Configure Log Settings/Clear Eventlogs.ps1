#requires -version 2
<#
.SYNOPSIS
  This script is used to clear the eventlogs
.DESCRIPTION
  Clear the logs post deployment
.PARAMETER <Parameter_Name>
    Required fields
	None
.INPUTS
    Not really required but tailor them to your environment
.OUTPUTS
    No OUTPUTS
.NOTES
  Version:        1.0
  Author:         Mark Quinn
  Creation Date:  7/29/2018
  Purpose/Change: Initial script development
  
.EXAMPLE
  Copy the file to the host and begin the configuraton
#>

Try {
    #attempting to clear the event logs
    Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log }
}

Catch {
    # Can be enabled to catch an error if required
 	$ErrorMessage = $_.Exception.Message
	$FailedItem = $_.Exception.ItemName
	Break
    # $_
}

Finally {
    # Event logs have been cleared
}
