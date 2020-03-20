# Install Global Protect VPN

cls

write-output "**** Installation of Global Protect VPN ****"
$computer = ""
$source = '\\172.16.42.3\deploy\Common'
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
        
        
        $os_type = invoke-command -cn $computer {(Get-WmiObject -Class Win32_ComputerSystem -Property SystemType).systemtype -match ‘(x64)’}
        #$os_type = (Get-WmiObject Win32_OperatingSystem -computername $computername).OSArchitecture


          if ($os_type -eq "True")  # Is it a 64BIT Machine?

             {

                "$computer has a 64BIT OS"
                robocopy $source "\\$computer\c$\source\install files" GlobalProtect64.msi
                write-output "Installing Global Protect VPN"
                psexec \\$computer -s msiexec /i "c:\source\install files\GlobalProtect64.msi" /q 2>&1

             }

           else   # 32BIT Machine?

             {

                "$computer has a 32BIT OS"
                robocopy $source "\\$computer\c$\source\install files" GlobalProtect.msi 
                psexec \\$computer -s msiexec /i "c:\source\install files\GlobalProtect.msi" /q 2>&1

             }
        
        
        
        

    }

      if (!(test-path \\$computer\c$))
        {write-warning "Computer unavailable"}



    }