#######################################################################################################
#Enable SQL AAG, AAG only
#Enable SQL Always on (run on both nodes)
#NOTE: This may fail once, wait a minute, then try again.
Enable-SqlAlwaysOn -ServerInstance $($env:ComputerName) -Confirm:$false -NoServiceRestart:$false -Force:$true
#End Enable SQL AAG, AAG only
#######################################################################################################
