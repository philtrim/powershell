# Script to scan computers for any software that is currently installed.
# Designed by Phillip Trimble, COT, Last updated 12/8/16.

cls

$computer = Read-Host -Prompt "Enter computer name ?"
$software = Read-Host -Prompt "Enter software to see if installed ?"


$message = "Probing IC Client Version..."
$ErrorActionPreference = "SilentlyContinue"

#$computers=(gc "c:\batchfiles\ic_client_list_final-9-6-16.txt")



$computername = @{
    Name = 'Computer Name'
    Expression = {$computer}
                }

write-host $message


 if (Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet)

    {
        Get-WmiObject -Class Win32_Product -Computer $computer -filter "Vendor like '%$software%'" | select-object $computername, Name, Version 
                
    }

if (!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
 
   {  
        write-host "$computer offline" -BackgroundColor Red
   }
    



