# Script copies all the neccesary RICPAY files on a local or remote machine.
# It also unzips the PSFTP files, installs Code39 font, Twain scanner driver and ScandAll software
# RICPAY is designed for County Attorney's so they can scan in their payments
# Spreadsheet passwords for the MASTER Sheet are - xerox and manofwar.
# Originally designed by Phillip Trimble, COT 6-12-2014
# Modified/Tested: 5/20/19
# Last run: 5/20/19

####################################################################################################################
####################################################################################################################

function inst-ricpay-local
    
    {
    
    # Copy Ricpay county specific files to computer...
    # _____________________________________________________________________________________
    write-host ""
    write-host "Copying County specific files to $env:COMPUTERNAME" -ForegroundColor Magenta
    New-Item "c:\ricpay" -type directory -force
    copy-item "$inst\RICPAY\$county\code39.ttf" "c:\ricpay\" -force 
    copy-item "$inst\RICPAY\$county\*.xlsm" "c:\ricpay\" -force 
    copy-item "$inst\RICPAY\$county\*.cab" "c:\ricpay\" -force 
    New-Item "c:\ricpay temp folder" -type directory -force
    copy-item "$inst\RICPAY\$county\*.tif" "c:\ricpay temp folder\" -Force 
    attrib +R "c:\ricpay temp folder\$code.tif" 
    New-Item "c:\program files\psftp" -type directory -force
    copy-item "$inst\RICPAY\$county\psftp.zip" "c:\program files\psftp\" -Force 

    # Install code39.ttf Font
    # _____________________________________________________________________________________
    write-host ""
    write-host "Installing CODE 39 Bar Code Font on $env:COMPUTERNAME" -ForegroundColor Magenta
    copy-item "$inst\RICPAY\install_code39.vbs" "c:\ricpay\" -Force
    copy-item "$inst\RICPAY\_fontreg.reg" "c:\ricpay\" -Force
    copy-item "$inst\RICPAY\copy_code39.cmd" "c:\ricpay\" -Force
    & cmd /c "c:\ricpay\copy_code39.cmd"
    & cmd /c "cscript c:\ricpay\install_code39.vbs"
    
    
    # Unzip PSFTP program...
    # _____________________________________________________________________________________
    write-host ""
    write-host "Unzipping PSFTP program on $env:COMPUTERNAME" -ForegroundColor Magenta
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace("c:\program files\psftp\psftp.zip")
    
    foreach($item in $zip.items())
        {
    
        $shell.Namespace("c:\program files\psftp\”).copyhere($item)

        }

    # Create Shortcut to Header Sheet
    # _____________________________________________________________________________________
    write-host ""
    write-host "Creating MASTERHEADERSHEET Desktop Shortcut on $env:COMPUTERNAME" -ForegroundColor Magenta
    $TargetFile = "c:\ricpay\ricpay"+$county+"master3.xlsm"
    $ShortcutFile = "c:\users\Public\Desktop\MASTERHEADERSHEET.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()
   
   # Install TWAIN Scanner Driver
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Installing TWAIN Scanner driver on $env:COMPUTERNAME" -ForegroundColor Magenta
    copy-item -path "$inst\RICPAY\Fujitsu Drivers\disk1\" "c:\" -force -recurse
    $size = Get-ChildItem c:\Disk1 |Measure-Object -sum length
    write-host ""
    write-host "Copying scanner driver files over to $env:COMPUTERNAME" -ForegroundColor White
    do {Start-sleep -seconds 1}
    while ($size.sum -lt 2215986)
    Start-Process msiexec.exe -Wait -Argumentlist '/i c:\disk1\pstwain\ext\psip_twain.msi /qn /norestart'
                       
   # Installing Fujitsu ScandAll
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Installing Fujitsu ScandAll on $env:COMPUTERNAME" -ForegroundColor Magenta
    copy-item -path "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup_en.msi" "c:\" -force
    copy-item -path "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup.cab" "c:\" -force
    Start-Process msiexec.exe -Wait -Argumentlist '/i c:\setup_en.msi /qn /norestart'

write-host ""
write-host "RICPAY Installation completed." -ForegroundColor Cyan

exit
    
  }

####################################################################################################################
####################################################################################################################

function inst-ricpay-remote

    {

    if (!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))

    {
        write-host "$computer offline" -BackgroundColor Red
        break
                
    }

  if (Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet)
 
    {  

        write-host "Installing RicPay on $computer"   -ForegroundColor Magenta
      


    # Copy Ricpay county specific files to computer...
    # _____________________________________________________________________________________
    write-host ""
    write-host "Copying County specific files to $computer" -ForegroundColor Magenta

    New-Item "\\$computer\c$\ricpay" -type directory -force
    copy-item "$inst\RICPAY\$county\code39.ttf" "\\$computer\c$\ricpay\" -force 
    copy-item "$inst\RICPAY\$county\*.xlsm" "\\$computer\C$\ricpay\" -force 
    copy-item "$inst\RICPAY\$county\*.cab" "\\$computer\C$\ricpay\" -force 
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
    invoke-command -cn $computer {Start-Process c:\ricpay\copy_code39.cmd}
    invoke-command -cn $computer {Start-Process cscript c:\ricpay\install_code39.vbs}

    
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
    copy-item -path "$inst\RICPAY\Fujitsu Drivers\disk1\" "\\$computer\c$\" -force -recurse
    $size = Get-ChildItem \\$computer\c$\Disk1 |Measure-Object -sum length
    write-host ""
    write-host "Copying scanner driver files over to $computer" -ForegroundColor Magenta
    do {Start-sleep -seconds 1}
    while ($size.sum -lt 2215986)
    invoke-command -cn $computer {Start-Process msiexec.exe -Wait -ArgumentList '/i c:\disk1\pstwain\ext\psip_twain.msi /qn /norestart'}
                       
   # Installing Fujitsu ScandAll
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Installing Fujitsu ScandAll on $computer" -ForegroundColor Magenta
    copy-item -path "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup_en.msi" "\\$computer\c$\" -force
    copy-item -path "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup.cab" "\\$computer\c$\" -force
    invoke-command -cn $computer {Start-Process msiexec.exe -Wait -ArgumentList '/i c:\setup_en.msi /qn /norestart'}
    
  }

write-host ""
write-host "RICPAY Installation completed." -ForegroundColor Cyan
exit
}

####################################################################################################################
# Main Program Code
####################################################################################################################

function global:Install-Ricpay

{

cls
#$cred = get-credential
cls
write-host ""
write-host "##### RICPAY Installation Script Version 2.20 #####" -ForegroundColor Magenta
write-host ""


$inst = '\\172.16.42.3\deploy'

write-host ""
$county = read-host -prompt "Enter County Name (i.e. Johnson) "

if ($county -eq "")
   {Install-Ricpay}

$code = read-host -prompt "Enter 3 Digit County Code (i.e. 058) "

if ($code -eq "")
   {Install-Ricpay}

$computer = read-host -prompt "Enter Computer Name, Press <ENTER> for Current computer"

  if ($computer -eq "")
    
    {inst-ricpay-local}
    
  if ($computer -ne "") 
     
     {inst-ricpay-remote}

}

# launch Main Program
Install-Ricpay
# End