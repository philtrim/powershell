# Script copies all the neccesary RICPAY files to mulitple machines. 
# It also unzips the PSFTP files
# RICPAY is designed for County Attorney's so they can scan in their payments
# Spreadsheet passwords for the MASTER Sheet are - xerox and manofwar.
# Designed using code from the Internet and put together by Phillip Trimble, NAIII, COT 6-12-2014
# Modified: 9/9/16


# To execute Open Powershell and at the Powershell Prompt
# type the following:  Install-Ricpay 'countyname' 'countycode'

function Install-RicPay 
{

    param ($county, $code, $computer)  #Example:  Install-Ricpay

cls
write-host "Processing..."  


$inst = '\\hfsro121-0581\oit'  # Change this to whatever location you want to store your install files in (I used this variable to shorten my path below)


# foreach ($computer in gc "C:\batchfiles\$county.txt")



 #   {

    # Copy files to each computer...
    # _____________________________________________________________________________________
    copy-item "$inst\_Projects\RICPAY\$county\code39.ttf" "\\$computer\c$\windows\fonts\" -force  # Modify this path to match the path of your install files
    New-Item "\\$computer\c$\ricpay" -type directory -force
    copy-item "$inst\_Projects\RICPAY\$county\code39.ttf" "\\$computer\c$\ricpay\" -force # Modify this path to match the path of your install files
    copy-item "$inst\_Projects\RICPAY\$county\*.xlsm" "\\$computer\c$\ricpay\" -force # Modify this path to match the path of your install files
    copy-item "$inst\_Projects\RICPAY\$county\*.cab" "\\$computer\c$\ricpay\" -force # Modify this path to match the path of your install files
    New-Item "\\$computer\c$\ricpay temp folder" -type directory -force
    copy-item "$inst\_Projects\RICPAY\$county\*.tif" "\\$computer\c$\ricpay temp folder\" -Force # Modify this path to match the path of your install files
    attrib +R "\\$computer\c$\ricpay temp folder\$code.tif" 
    New-Item "\\$computer\c$\program files\psftp" -type directory -force
    copy-item "$inst\_Projects\RICPAY\$county\psftp.zip" "\\$computer\c$\program files\psftp\" -Force # Modify this path to match the path of your install files

    # Install code39.ttf Font
    # _____________________________________________________________________________________
    $fonts=0x14
    $objshell = new-object -comobject shell.application
    $objfolder = $objshell.namespace($fonts)
    $objfolder.copyhere("c:\$computer\c$\ricpay\code39.ttf")
    
    # Unzip PSFTP program...
    # _____________________________________________________________________________________
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace("\\$computer\c$\program files\psftp\psftp.zip")
    foreach($item in $zip.items())
        {
        $shell.Namespace("\\$computer\c$\program files\psftp\”).copyhere($item)
        }

  #  }

    }
    # End of Code...
    # ______________________________________________________________________________________
    # ______________________________________________________________________________________