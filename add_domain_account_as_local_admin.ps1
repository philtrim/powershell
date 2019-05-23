<#

Add a domain user to the local administrators group on one or more remote computers
Last updated or used - 1/7/19
 
#>


$ErrorActionPreference = "SilentlyContinue"

cls
$computers = read-host -Prompt "Enter computer name FQDN"
#$computers = get-content "c:\batchfiles\thelma_need_temp_admin.txt"
$userName = Read-host "Enter UserName"
$userDomain = Read-Host "Enter Domain"
$localGroupName = 'GP - Administrators'
#$suffix = $userdomain+"."+$userdomain

ForEach ($computer in $computers) 

 {
    
    if (!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))

     {
        write-host "$computer offline" -BackgroundColor Red
        
                
     }

   if (Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet)

     {
         try
         {
    
            ([ADSI]"WinNT://$computer/$localGroupName,group").Invoke('Add', "WinNT://$userdomain/$username")  
            write-host ""
            write-host "$userName added to Local Admin Group on $computer" -ForegroundColor DarkGreen
         }
       
         catch
       
         { 
            Write-Error "User already exists, or something else went awry!"
         }     
     }
      
    
 }




