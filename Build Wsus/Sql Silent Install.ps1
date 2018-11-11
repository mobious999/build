#Set-Location to where your SQL Setup.exe is located, then run:
$params = @'
/ACTION=Install /QS /FEATURES=SQL /INSTANCENAME=MSSQLSERVER /HIDECONSOLE /INDICATEPROGRESS="True" /IAcceptSQLServerLicenseTerms /SQLSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE" /SQLSYSADMINACCOUNTS="builtin\administrators" /SKIPRULES="RebootRequiredCheck" 
'@ 
Start-process .\setup.exe $params -wait