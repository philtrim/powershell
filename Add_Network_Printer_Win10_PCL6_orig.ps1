<#  Script to install local IP printer and driver.
    Works 64 bit systems only.
    Designed and originally created by Phillip Trimble, COT, 2015.
    Updated/Last Updated 12/9/19 #>


cls

$user = 'eas\eas-phillip.trimble'
$password = read-host -Prompt "Enter your password " -Assecurestring
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
write-host ""
write-output "**** Install Network Printer ****"

$howmanyprinters = read-host "Enter number of printers"
$computers = read-host "Enter Computer(s)"
$computers = $computers.split(",")
#$printername = read-host "Enter Printer Name "
#$ipaddress = read-host "Enter Printer IP Address "

foreach ($computer in $computers)
    
    {
    
        if (test-path \\$computer\c$)

          {

            for ($i=0; $i -lt $howmanyprinters; $i++)
        
               {                                
                
                $printername = read-host "Enter Printer Name"
                $ipaddress = read-host "Enter Printer IP Address "
        
                write-host ""
                write-host ""
                write-host "Installing $printer on $computer"
                write-host ""
                write-host ""

                robocopy "c:\deploy\drivers\Xerox64" "\\$computer\c$\printdrv" /e /w:0 /r:0 /np /ipg:100
                cscript "c:\Deploy\prnport.vbs" -a -s $computer -r IP_$ipaddress -h $ipaddress -o raw -n 9100
                cscript "c:\Deploy\prndrvr.vbs" -a -s $computer -m "Xerox Global Print Driver PCL6" -e "Windows x64" -i "c:\printdrv\x3UNIVX.inf" -h "c:\printdrv" -u $user -w $decodedpassword
                cscript "c:\deploy\prnmngr.vbs" -a -s $computer -p $printername -m "Xerox Global Print Driver PCL6" -r IP_$ipaddress -u $user -w $decodedpassword
                cscript "c:\Deploy\prnqctl.vbs" -e -s $computer -p $printername -u $user -w $decodedpassword
                write-output ""
                cscript "c:\Deploy\prnmngr.vbs" -s $computer -l | findstr "$printername"
          
               }
       
            
            
       }

        
        if (!(Test-Path \\$computer\c$))

             {
                write-host "$computer offline" -BackgroundColor Red
                exit
                
             }

        }





echo 'Printer install complete!'

