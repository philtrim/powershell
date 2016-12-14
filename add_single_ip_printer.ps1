# Quick script to install local printer driver for machines without full options
# Designed and created by Phillip Trimble, COT, 2015.

Echo 'Installing local printers....'

$user = 'eas\eas-phillip.trimble'
$password = 'B@ptivity0117'
$printername = 'Xerox01-Local-Johnson Co'
$ipaddress = '172.16.42.236'

foreach($computer in ('HFPPL0581XT5K12'))

    {

        if (!(test-path -path "\\$computer\c$\printdrv\xunivxpl.ini"))
            
            {
                c:\batchfiles\psexec.exe \\$computer -u $user -p $password xcopy /E /Y \\hfsro121-0581\e$\Deploy\Drivers\Xerox\GPD\*.* c:\printdrv\
            }

    cscript "\\hfsro121-0581\e$\Deploy\prnport.vbs" -a -s $computer -r IP_$ipaddress -h $ipaddress -o raw -n 9100 
    cscript "\\hfsro121-0581\e$\Deploy\prndrvr.vbs" -a -s $computer -m "Xerox Global Print Driver PCL6" -e "Windows NT x86" -h "c:\printdrv" -i "c:\printdrv\x2UNIVX.inf" -u $user -w $password
    cscript "\\hfsro121-0581\e$\deploy\prnmngr.vbs" -a -s $computer -p $printername -m "Xerox Global Print Driver PCL6" -r IP_$ipaddress -u $user -w $password
    cscript "\\hfsro121-0581\e$\Deploy\prnqctl.vbs" -e -s $computer -p $printername -u $user -w $password
    
    }

echo 'Printer install complete!'