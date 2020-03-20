cls
write-output "**** KL License Fix ****"
$computer = read-host "Enter computer name"

if (test-path \\$computer\c$\users)

    {
       
       try {$os = invoke-command -cn $computer {(Get-WmiObject Win32_OperatingSystem).OSArchitecture}}
       catch {write-warning "Remote access is being blocked"
       exit
       
              }



        If ($os -eq "64-bit")
            {
            invoke-command -cn $computer {& cmd /c reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\KnowledgeLake\KLS\KnowledgeLake Capture" /v Path /f}
            invoke-command -cn $computer {& cmd /c reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\KnowledgeLake\KLS\KnowledgeLake Capture" /v NotificationLastDisplayedDate /f}
            }

        else 
            {
            invoke-command -cn $computer {& cmd /c reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\KnowledgeLake\KLS\KnowledgeLake Capture" /v Path /f}
            invoke-command -cn $computer {& cmd /c reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\KnowledgeLake\KLS\KnowledgeLake Capture" /v NotificationLastDisplayedDate /f}
            }


        invoke-command -cn $computer {& cmd /c rmdir c:\programdata\KnowledgeLake\KLS /s /q}

    }

else {write-warning "Computer offline, or otherwise inaccessable"}
