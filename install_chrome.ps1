cls

Write-Output "**** Install Chrome Browser ****"

$user = 'eas\eas-phillip.trimble'
$password = read-host -Prompt "Enter your password " -Assecurestring
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

foreach ($computer in gc c:\batchfiles\johnson_training_lab_need_chrome.txt)

    {

        

        new-item -path "c:\" -name "Source" -Itemtype "directory" -Force
        new-item -path "c:\source" -name "Install Files" -Itemtype "directory" -Force

        $source = "\\172.16.42.3\deploy\chfs\install files"
        #$dest = "c:\source\install files"

        robocopy $source "\\$computer\c$\source\Install files" ChromeSetup.exe /e /w:0 /r:0 /np

        #set-location $dest
        
        write-output "Installing Chrome"
        
        #start-sleep -Seconds 10
        
        psexec.exe \\$computer -s -u $user -p $decodedpassword  "c:\source\install files\ChromeSetup.exe" /silent /install

        #invoke-command -cn $computer {c:\source\"install files"\ChromeSetup.exe /silent /install}
        #invoke-command -cn $computer {Start-Process msiexec.exe -Wait -ArgumentList '/i c:\source\setup_en.msi /qn /norestart'}

    }