# Installing Fujitsu ScandAll

    
    cls
    write-output "**** Install ScandAll ****"

    $inst = '\\172.16.42.3\deploy'
    
    $computer = read-host "Enter Computer Name"
    
    if (test-path \\$computer\c$)

        {
    

            write-host ""
            write-host "Installing Fujitsu ScandAll on $computer" -ForegroundColor Magenta
            new-item -Path \\$computer\c$\source -ItemType Directory
            copy-item -path "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup_en.msi" "\\$computer\c$\source" -force
            copy-item -path "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup.cab" "\\$computer\c$\source" -force
            invoke-command -cn $computer {Start-Process msiexec.exe -Wait -ArgumentList '/i c:\source\setup_en.msi /qn /norestart'}


        }
    else {write-warning "Invalid computer name or computer offline!!"
          exit}

