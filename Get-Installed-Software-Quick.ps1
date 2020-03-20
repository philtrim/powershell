﻿# Script to see what software is installed on a remote computer. Phillip Trimble, COT, 3/2019

cls

write-output "**** Get Installed Software ****"
$computers = read-host "Enter Computer"

foreach ($computer in $computers)

{

if (test-path -path \\$computer\c$)

        {

        try {

        Get-WmiObject -Class Win32_Product -Computer $computer | select-object @{Name="ComputerName";Expression={$computer}}, Name, Version, InstallDate | where-object {$_.Name -notlike "Microsoft*" -and $_.Name -like "*GlobalProtect*"}
            
            }
        
        catch{
                write-warning "Something went amiss"
             }

         }  
         
if (!(test-path -path \\$computer\c$))     

        {write-warning "$computer IS NOT ONLINE!"}


}





