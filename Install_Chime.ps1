# Install Global Protect VPN
cls
write-output "**** Installation of Amazon Chime ****"
$computer = ""
$source = '\\172.16.42.3\deploy\common'
$dest = "$computer\c$\source\install files"

foreach ($computer in ($computers = read-host "Enter Computer")) #gc C:\batchfiles\johnson_training_lab_7020.txt)

    {
         
      if (test-path \\$computer\c$) 

      {
      
        $user = 'eas\eas-phillip.trimble'
        $password = read-host -Prompt "Enter your password " -Assecurestring
        $decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
        
        new-item -path \\$computer\c$ -name "Source" -Itemtype "directory" -Force
        new-item -path \\$computer\c$\source -name "Install Files" -Itemtype "directory" -Force
        
        
        robocopy $source "\\$computer\c$\source\install files" Chime.exe 
        
        write-output "Installing Global Protect VPN"
        
        psexec \\$computer -s "c:\source\install files\chime.exe" /verysilent /nas

    }

      if (!(test-path \\$computer\c$))
        {write-warning "Computer unavailable"}



    }