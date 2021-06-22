# Script copies all the neccesary RICPAY files on a local or remote machine.
# It also unzips the PSFTP files, installs Code39 font, Twain scanner driver and ScandAll software
# RICPAY is designed for County Attorney's so they can scan in their payments
# Spreadsheet passwords for the MASTER Sheet are - xerox and manofwar.
# Originally designed by Phillip Trimble, COT 6-12-2014
# Latest version modified/tested: 5/28/19
# Additions/updates 5/29/19 - Located "Detail Scanner Settings" ini file called FJTW0000.ini
# This file is stored in the users\username\appdata\roaming\fujitsu\fjtwain\ folder
# Last updated: 5/27/21 - Added BITSTransfer copy
####################################################################################################################
####################################################################################################################
Set-ExecutionPolicy -Scope CurrentUser Unrestricted -Force

#if (!(net session)) {$path =  "& '" + $myinvocation.mycommand.definition + "'" ; Start-Process powershell -Verb runAs -ArgumentList $path ; exit}

$global:rc = ""
$global:bt = ""

try {import-module bitstransfer -erroraction Stop
     write-host "Bits-Transfer Module loaded successfully!"
     $bt = "1"}

catch {write-warning "Could not load the module BitsTransfer"
        pause
        $rc = "1"}

function inst-ricpay-local
    
  {
    
    # Copy Ricpay county specific files to local computer...
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
    copy-item "$inst\RICPAY\favorites.ico" "c:\ricpay\"
    $Shortcut.IconLocation = "c:\RICPAY\favorites.ico"
    $Shortcut.Save()
   
   # Install TWAIN Scanner Driver
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Copying scanner driver files over to $env:COMPUTERNAME" -ForegroundColor Magenta
    robocopy "$inst\RICPAY\Fujitsu Drivers\disk1" "c:\disk1" /e /w:0 /r:1 /np /j /z
    write-host ""
    write-host "Installing TWAIN Scanner driver on $env:COMPUTERNAME" -ForegroundColor Magenta
    Start-Process msiexec.exe -wait -Argumentlist '/i c:\disk1\pstwain\ext\psip_twain.msi /qn /norestart'
                       
   # Installing Fujitsu ScandAll - Changed this 5/25/21 to make it a little faster....
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Installing Fujitsu ScandAll on $env:COMPUTERNAME" -ForegroundColor Magenta
    write-host "Please be patient, depending on network speed, this could take several minutes"
   # if ($bt = "1")
   #     {Start-BitsTransfer -Source "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup_en.msi" -Destination "c:\source\setup_en.msi" 
   #      Start-BitsTransfer -Source "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup.cab" -Destination "c:\source\setup.cab" }
   # if ($rc = "1")
   #     {robocopy "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1" "c:\source" "setup_en.msi" /np /j /z
   #     robocopy "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1" "c:\source" "setup.cab" /np /j /z}
     Start-Process msiexec.exe -wait -Argumentlist '/i "\\172.16.42.3\deploy\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup_en.msi" /qn /norestart'
   # Start-Process msiexec.exe -wait -Argumentlist '/i "c:\source\setup_en.msi" /qn /norestart' 


write-host ""
write-host "RICPAY Installation completed." -ForegroundColor Cyan
pause
exit
    
  } # End Install Ricpay Local Function

####################################################################################################################
####################################################################################################################

function global:inst-ricpay-remote

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
    copy-item "$inst\RICPAY\code39.ttf" "\\$computer\c$\windows\fonts\" -Force
    #invoke-command -cn $computer {Start-Process c:\ricpay\copy_code39.cmd}
    #invoke-command -cn $computer {Start-Process cscript.exe c:\ricpay\install_code39.vbs}
    
    \\172.16.42.3\deploy\PsExec.exe \\$computer cscript.exe c:\ricpay\install_code39.vbs -accepteula

    
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
    copy-item "$inst\RICPAY\favorites.ico" "\\$computer\c$\ricpay\"
    $Shortcut.IconLocation = "c:\ricpay\favorites.ico"
    $Shortcut.Save()
   
   # Install TWAIN Scanner Driver
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Copying scanner driver files over to $computer" -ForegroundColor Magenta
    robocopy "$inst\RICPAY\Fujitsu Drivers\disk1" "\\$computer\c$\disk1" /e /np /w:0 /r:0 /j /z
    write-host ""
    write-host "Installing TWAIN Scanner driver on $computer" -ForegroundColor Magenta
    invoke-command -cn $computer {Start-Process msiexec.exe -Argumentlist -wait '/i "c:\disk1\pstwain\ext\psip_twain.msi" /qn /norestart'}
                       
   # Installing Fujitsu ScandAll - Changed this 5/25/21 to make it a little faster....
   # _______________________________________________________________________________________________________________
    write-host ""
    write-host "Installing Fujitsu ScandAll on $computer" -ForegroundColor Magenta
    write-host "Please be patient, depending on network speed, this could take several minutes"
    #if ($bt = "1")
    #    {Start-BitsTransfer -Source "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup_en.msi" -Destination "\\$computer\c$\source\setup_en.msi"
    #    Start-BitsTransfer -Source "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1\setup.cab" -Destination "\\$computer\c$\source\setup.cab"}
    #if ($rc = "1")
    #    {robocopy "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1" "\\$computer\c$\source" "setup_en.msi" /np /j /z
    #    robocopy "$inst\RICPAY\ScandAll\ScandAll 2.0.11\SDATA1" "\\$computer\c$\source" "setup.cab" /np /j /z}
    #Start-Process msiexec.exe -passthru -Argumentlist '/i \\$computer\c$\source\setup_en.msi /qn /norestart'
    #invoke-command -cn $computer {Start-Process msiexec.exe -wait -ArgumentList '/i "c:\source\setup_en.msi" /qn /norestart'}
    invoke-command -cn $computer {Start-Process msiexec.exe -wait -ArgumentList '/i "\\172.16.42.3\deploy\ricpay\scandall\ScandAll 2.0.11\SDATA1\setup_en.msi" /qn /norestart'}
                                

write-host ""
write-host "RICPAY Installation completed." -ForegroundColor Cyan
exit} #end test remote computer
pause
} # End Install Ricpay Remote Function

####################################################################################################################
# Main Program Code
####################################################################################################################

function global:Install-Ricpay

{

#$cred = get-credential
cls
write-host ""
write-host "##### RICPAY Installation Script Version 2.21 #####" -ForegroundColor Magenta
write-host ""


$global:inst = '\\172.16.42.3\Deploy'

write-host ""
$county = read-host -prompt "Enter County Name (i.e. Johnson) "

county-check

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

} # End Install Ricpay Function

function global:county-check

{
$match=0
$counties = get-childitem $inst\ricpay

foreach ($co in $counties)

  {
    if ($co -like $county)
    {$match=1
    write-output "County matched"
    continue}
    
  }

if ($match -eq 0)

    {write-output "Invalid County, or County does not exist!"
     pause
     Install-Ricpay}
} # End County-Check Function


# launch Main Program
Install-Ricpay
# End