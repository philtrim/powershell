#:: Script for Installing IP Printers on computers that are pulled from a text file
#:: The variables that need to change are the IP Address (for the different printers)
#:: and the Department where the printer is in (which is added to the printer name on install)
#:: Modifed and customized by Phillip Trimble, COT, 7/24/2014 (last updated 5-15)
#:: Was used initially for converting queue printers at Thelma OVR over to IP printers.

# Variables for user name and password

cd c:\batchfiles

cls

$user='eas\eas-phillip.trimble'
$password='B@ppy0415'

# Set IP address, office and printer name

$ipaddress = Read-Host 'Enter Printer IP Address '
$office = Read-Host 'Enter County (county.txt) '
$printername = Read-Host 'Enter Printer Name '

#$ipaddress = '10.65.10.182'
#$office = 'boyd-kyova mall.txt'
#$printername = "Xerox WorkCentre 5945"

# Begin Looping through computers

cls 
write-host "Processing started..."
write-host 



    foreach ($computer in gc c:\batchfiles\ccpr\$office)

    {

    
    # Is computer $computer accessable?

    if (test-path -path "\\$computer\admin$")

        {

        echo "$computer accessible" >>c:\batchfiles\ccpr\log\"success_log_"$office

        # REM Printer1
        # REM Deletes previously installed printer of the specified name

        # echo Deleting previously installed printer 

        cscript "\\hfsro121-0581\e$\Deploy\prnmngr.vbs" -d -s $computer -p $printername
 
        #echo END Deleted Previously installed printer 

        #REM Deletes static port of previous printer, in case of mis-configuration
        #echo Deleting existing port

        cscript "\\hfsro121-0581\e$\Deploy\prnport.vbs" -d -s $computer -r IP_$ipaddress 

        #echo END Deleted IP port  

        #REM Creates TCP/IP port with specified IP address
        #echo Creating new port
        
        cscript "\\hfsro121-0581\e$\Deploy\prnport.vbs" -a -s $computer -r IP_$ipaddress -h $ipaddress -o raw -n 9100 
        
        #echo END Created IP Port 

        #REM Copies driver for printer from server to local directory
        #echo Copying drivers to remote machine

        # Have I already copied the printer drivers to this computer, if so, not going to do it again!
                
        if (!(test-path -path "\\$computer\c$\printdrv\xunivxpl.ini"))
         
            {
        
            # Copying printer driver files to the remote computer

            c:\batchfiles\psexec.exe \\$computer -u $user -p $password xcopy /E /Y \\hfsro121-0581\e$\Deploy\Drivers\Xerox\GPD\*.* c:\printdrv\
                             

            }
                    
        
       cscript "\\hfsro121-0581\e$\Deploy\prndrvr.vbs" -a -s $computer -m "Xerox Global Print Driver PCL6" -e "Windows NT x86" -h "c:\printdrv" -i "c:\printdrv\x2UNIVX.inf" 

       cscript "\\hfsro121-0581\e$\deploy\prnmngr.vbs" -a -s $computer -p $printername -m "Xerox Global Print Driver PCL6" -r IP_$ipaddress

       cscript "\\hfsro121-0581\e$\Deploy\prnqctl.vbs" -e -s $computer -p $printername -u %user% -w %password%

       
	}
    
    else 
        {
        echo "$computer not accessible" >>c:\batchfiles\ccpr\log\"error_log_"$office
        }
}

cls

write-host "Confirming printer driver installation..."
write-host 

foreach ($computer in gc c:\batchfiles\ccpr\$office)

    {
    
        if (cscript prnmngr.vbs -s $computer -l | findstr "$printername")

    {

    echo "Printer installed on $computer"

    }
    else 
        {echo "Printer not installed on $computer"}

    }
    
write-host
write-host Processing complete for $office
# END