cls

write-output "**** Check for GLOBAL PROTECT VPN ****"

$computer = read-host "Enter Computer Name"
$results = ""
$os_type = invoke-command -cn $computer {(Get-WmiObject -Class Win32_ComputerSystem -Property SystemType).systemtype -match ‘(x64)’}
        #$os_type = (Get-WmiObject Win32_OperatingSystem -computername $computername).OSArchitecture


          if ($os_type -eq "True")  # Is it a 64BIT Machine?

             {

                "$computer has a 64BIT OS"
                $results = (invoke-command -cn $computer {Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | `
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | where-object {$_.Name -notlike "*Microsoft*" -and $_.Name `
                -like "*GlobalProtect*"} | Sort-Object InstallDate -Descending | Format-Table –AutoSize})

             }

           else   # 32BIT Machine?

             {

                "$computer has a 32BIT OS"
                $results =  (invoke-command -cn $computer {Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | `
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | where-object {$_.Name -notlike "*Microsoft*" -and $_.Name `
                -like "*GlobalProtect*"} | Sort-Object InstallDate -Descending | Format-Table –AutoSize | Format-Table –AutoSize})

             }

             

if ($results)
    
        {
            write-output "$computer DOES have the GP-VPN Installed"

        }

else    { write-warning "$computer DOES NOT have the GP-VPN installed"}


#KTC07DD20ZZ12.kytc.ds.ky.gov
