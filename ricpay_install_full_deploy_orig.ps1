# Script copies all the neccesary RICPAY files to one or more machines. 
# It also unzips the PSFTP files, installs Code39 font, Twain scanner driver and ScandAll software
# RICPAY is designed for County Attorney's so they can scan in their payments
# Spreadsheet passwords for the MASTER Sheet are - xerox and manofwar.
# Designed using code from the Internet and put together by Phillip Trimble, NAIII, COT 6-12-2014
# Modified/Tested: 10/24/18
# Last run: 5/20/19

cls
write-host ""
write-host "##### RICPAY Installation Script Version 2.01 #####" -ForegroundColor Magenta
write-host ""
$user = read-host -prompt "Enter user name (i.e. eas\eas-username) "
#$user = "eas\eas-phillip.trimble" #read-host -prompt "Enter user name (i.e. eas\eas-username) "
$password=read-host -Prompt "Enter your password " -Assecurestring
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$county = read-host -prompt "Enter County Name (i.e. Johnson) "
$code = read-host -prompt "Enter 3 Digit County Code (i.e. 058) "
$computer = read-host -prompt "Enter Computer Name (i.e. HFAT0581234567.domain.ds.ky.gov) "

    if (!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))

    {
        write-host "$computer offline" -BackgroundColor Red
        break
                
    }

if (Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet)
 
   {  

    write-host "Installing RicPay on $computer"   -ForegroundColor Magenta
    $inst = '\\172.16.42.3\deploy'  


    # Copy Ricpay county specific files to computer...
    # _____________________________________________________________________________________
    write-host ""
    write-host "Copying County specific files to $computer" -ForegroundColor Magenta
    New-Item "\\$computer\c$\ricpay" -type directory -force
    copy-item "$inst\RICPAY\$county\code39.ttf" "\\$computer\c$\ricpay\" -force 
    copy-item "$inst\RICPAY\$county\*.xlsm" "\\$computer\c$\ricpay\" -force 
    copy-item "$inst\RICPAY\$county\*.cab" "\\$computer\c$\ricpay\" -force 
    New-Item "\\$computer\c$\ricpay temp folder" -type directory -force
    copy-item "$inst\RICPAY\$county\*.tif" "\\$computer\c$\ricpay temp folder\" -Force 
    attrib +R "\\$computer\c$\ricpay temp folder\$code.tif" 
    New-Item "\\$computer\c$\program files\psftp" -type directory -force
    copy-item "$inst\RICPAY\$county\psftp.zip" "\\$computer\c$\program files\psftp\" -Force 

    # Install code39.ttf Font
    # _____________________________________________________________________________________
    write-host ""
    write-host "Installing CODE 39 Bar Code Font on $computer" -ForegroundColor Magenta
    copy-item "$inst\RICPAY\install_code39.vbs" "\\$computer\c$\ricpay\" -Force
    copy-item "$inst\RICPAY\_fontreg.reg" "\\$computer\c$\ricpay\" -Force
    copy-item "$inst\RICPAY\copy_code39.cmd" "\\$computer\c$\ricpay\" -Force
    c:\batchfiles\psexec.exe \\$computer -u $user -p $decodedpassword -h c:\ricpay\copy_code39.cmd 2>results.log
    c:\batchfiles\psexec.exe \\$computer -u $user -p $decodedpassword -h -d cscript c:\ricpay\install_code39.vbs 2>results.log
    
    # Unzip PSFTP program...
    # _____________________________________________________________________________________
    write-host ""
    write-host "Unzipping PSFTP program on $computer" -ForegroundColor Magenta
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace("\\$computer\c$\program files\psftp\psftp.zip")
    foreach($item in $zip.items())
        {
        $shell.Namespace("\\$computer\c$\program files\psftp\”).copyhere($item)

        }

    # Create Shortcut to Header Sheet
    # _____________________________________________________________________________________
    write-host ""
    write-host "Creating MASTERHEADERSHEET Desktop Shortcut on $computer" -ForegroundColor Magenta
    $TargetFile = "c:\ricpay\ricpay"+$county+"master3.xlsm"
    $ShortcutFile = "\\$computer\c$\users\Public\Desktop\MASTERHEADERSHEET.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()
   
   # Install TWAIN Scanner Driver
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Installing TWAIN Scanner driver on $computer" -ForegroundColor Magenta
    copy-item -path "\\172.16.42.3\Deploy\RICPAY\Fujitsu Drivers\disk1\" "\\$computer\c$\" -force -recurse
    $size = Get-ChildItem \\$computer\c$\Disk1 |Measure-Object -sum length
    write-host ""
    write-host "Copying scanner driver files over to $computer" -ForegroundColor White
    do {Start-sleep -seconds 1}
    while ($size.sum -lt 2215986)
    c:\batchfiles\psexec.exe \\$computer -u $user -p $decodedpassword -h msiexec.exe /i c:\disk1\pstwain\ext\psip_twain.msi /qn /norestart 2>results.log

               
   # Installing Fujitsu ScandAll
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Installing Fujitsu ScandAll on $computer" -ForegroundColor Magenta
    copy-item -path "\\172.16.42.3\Deploy\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup_en.msi" "\\$computer\c$\" -force
    copy-item -path "\\172.16.42.3\Deploy\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup.cab" "\\$computer\c$\" -force
    c:\batchfiles\psexec.exe \\$computer -u $user -p $decodedpassword -h msiexec.exe /i c:\setup_en.msi /qn /norestart 2>results.log

  }

write-host ""
write-host "RICPAY Installation completed." -ForegroundColor Cyan


# End of Code...
# ______________________________________________________________________________________
# ______________________________________________________________________________________

