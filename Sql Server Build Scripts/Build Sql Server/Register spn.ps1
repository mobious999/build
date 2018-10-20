#######################################################################################################
#Register SPNs
Start-process -FilePath setspn -ArgumentList "-A MSSQLSvc/$($ComputerName).YOURDOMAINHERE.local:1433 $($sqlserviceuserNoDomain) " -NoNewWindow -Wait -PassThru
Start-process -FilePath setspn -ArgumentList "-A MSSQLSvc/$($ComputerName).YOURDOMAINHERE.local $($sqlserviceuserNoDomain) " -NoNewWindow -Wait -PassThru
#END Register SPNs
#######################################################################################################
