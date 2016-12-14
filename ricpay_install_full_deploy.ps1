# Script copies all the neccesary RICPAY files to mulitple machines. 
# It also unzips the PSFTP files
# RICPAY is designed for County Attorney's so they can scan in their payments
# Spreadsheet passwords for the MASTER Sheet are - xerox and manofwar.
# Designed using code from the Internet and put together by Phillip Trimble, NAIII, COT 6-12-2014
# Modified: 12/13/16

cls
  
$county = read-host -prompt "Enter County Name (i.e. Johnson) "
$code = read-host -prompt "Enter 3 Digit County Code (i.e. 058) "
$computer = read-host -prompt "Enter Computer Name (i.e. HFAT0581234567) "

    if (!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))

    {
        write-host "$computer offline" -BackgroundColor Red
        break
                
    }

if (Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet)
 
   {  

    write-host "Installing RicPay on $computer"   
    $inst = '\\hfsro121-0581\deploy'  


    # Copy files to each computer...
    # _____________________________________________________________________________________
    copy-item "$inst\RICPAY\$county\code39.ttf" "\\$computer\c$\windows\fonts\" -force  
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
    $fonts=0x14
    $objshell = new-object -comobject shell.application
    $objfolder = $objshell.namespace($fonts)
    $objfolder.copyhere("\\$computer\c$\ricpay\code39.ttf")
    
    # Unzip PSFTP program...
    # _____________________________________________________________________________________
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace("\\$computer\c$\program files\psftp\psftp.zip")
    foreach($item in $zip.items())
        {
        $shell.Namespace("\\$computer\c$\program files\psftp\”).copyhere($item)
        }


}
# End of Code...
# ______________________________________________________________________________________
# ______________________________________________________________________________________