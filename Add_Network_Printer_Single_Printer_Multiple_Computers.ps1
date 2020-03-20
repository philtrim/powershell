# Installs network printer on either 32bit or 64bit platforms.
# Allows you to install multiple printers for each computer, or just one for many computers.

cls
write-output "**** Install Single Printer on Multiple Computers ****"
$user = 'eas\eas-phillip.trimble'
$password = read-host -Prompt "Enter your password " -Assecurestring
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$printername = read-host "Enter Printer Name "
$ipaddress = read-host "Enter Printer IP Address "
#$computers = read-host "Enter Computers, Separated by Comma, no Spaces"
$computers = get-content c:\batchfiles\regional_need_xerox04.txt
 #$computers = $computers.split(",")

foreach ($computer in $computers)

    
    {
    
        if (test-path \\$computer\c$)

          {

        
        
        $os_type = (Get-WmiObject -Class Win32_ComputerSystem -cn $computer).SystemType -match ‘(x64)’

        if ($os_type -eq "True")  # Is it a 64BIT Machine?   
                
              {  
                write-host ""
                write-host ""
                write-host "Processing..."
                write-host ""
                write-host ""

                robocopy "c:\deploy\drivers\Xerox64" "\\$computer\c$\printdrv" /e /w:5 /r:1 /np 
                #cscript "c:\Deploy\prnport.vbs" -d -s $computer -r IP_$ipaddress
                cscript "c:\Deploy\prnport.vbs" -a -s $computer -r IP_$ipaddress -h $ipaddress -o raw -n 9100
                cscript "c:\Deploy\prndrvr.vbs" -a -s $computer -m "Xerox Global Print Driver PCL6" -e "Windows x64" -i "c:\printdrv\x3UNIVX.inf" -h "c:\printdrv" -u $user -w $decodedpassword
                cscript "c:\deploy\prnmngr.vbs" -a -s $computer -p $printername -m "Xerox Global Print Driver PCL6" -r IP_$ipaddress -u $user -w $decodedpassword
                cscript "c:\Deploy\prnqctl.vbs" -e -s $computer -p $printername -u $user -w $decodedpassword
                
              }
                
          
         else 
         
              {                                                                                 
         
                write-host ""
                write-host ""
                write-host "Processing..."
                write-host ""
                write-host ""

                robocopy "c:\deploy\drivers\Xerox32" "\\$computer\c$\printdrv" /e /w:5 /r:1 /np 
                #cscript "c:\Deploy\prnport.vbs" -d -s $computer -r IP_$ipaddress
                cscript "c:\Deploy\prnport.vbs" -a -s $computer -r IP_$ipaddress -h $ipaddress -o raw -n 9100
                cscript "c:\Deploy\prndrvr.vbs" -a -s $computer -m "Xerox Global Print Driver PCL6" -e "Windows NT x86" -i "c:\printdrv\x3UNIVX.inf" -h "c:\printdrv" -u $user -w $decodedpassword
                cscript "c:\deploy\prnmngr.vbs" -a -s $computer -p $printername -m "Xerox Global Print Driver PCL6" -r IP_$ipaddress -u $user -w $decodedpassword
                cscript "c:\Deploy\prnqctl.vbs" -e -s $computer -p $printername -u $user -w $decodedpassword
                            
              } 
          
          
          }
       
            
            
       }
