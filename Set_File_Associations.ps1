# Script to set custom Application Association settings for PDF = Adobe and Internet = Internet Explorer
# Needs to be ran prior to users logging in.
# Designed by Phillip Trimble, COT, 12/11/2018
# Last updated 12/21/2018

cls

#$user = 'eas\eas-phillip.trimble'
#$password = read-host -Prompt "Enter your password " -Assecurestring
#$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
#$credential = get-credential eas\eas-phillip.trimble
$computers = read-host -prompt "Enter computer name(s)"

foreach ($computer in $computers)

  {

        if (!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
        
             {
                write-host "$computer offline" -BackgroundColor Red
                return
                        
             }

        write-host ""
        write-host "Processing file association settings for $computer"
        copy-item \\172.16.42.3\e$\deploy\set_app_assoc.reg \\$computer\c$ -force
        copy-item \\172.16.42.3\e$\deploy\CustomAppAssoc.xml \\$computer\c$\windows\system32\ -force
        invoke-command -cn $computer {regedit.exe /s c:\set_app_assoc.reg}
        #c:\batchfiles\psexec.exe -s -u $user -p $decodedpassword \\$computer regedit.exe /s c:\set_app_assoc.reg 2>null
  }

write-host ""
write-host "Process completed" -BackgroundColor DarkCyan