#upload file to bits

import-Module BitsTransfer -Force            
            
$computername = "WebR201"            
$source = "c:\source\transfer\"            
            
Get-ChildItem -Path $source |            
foreach {            
             
$destination =  "http://webr201/transfer/$($_.name)"            
Write-Host "Transferring $($_.Fullname) to $destination"            
            
Start-BitsTransfer -Source $($_.Fullname) -Destination $destination -TransferType Upload            
            
}

#Start-BitsTransfer -Source c:\source\transfer\testupload.txt -Destination http://webr201/transfer/testupload.txt -TransferType Upload