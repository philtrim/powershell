# Script designed to push out ODBC Settings for DNR - Oil & Gass Database
# Phillip Trimble - 5-11-21
cls

$computer = read-host "Enter computer name"
$access = test-path \\$computer\c$

if ($access)

    {
        
    robocopy "\\172.16.42.3\deploy\eec\SQL-OILGAS Database" "\\$computer\c$\source\odbc" "oil-and-gas-system-odbc.reg" 
    invoke-command -cn $computer {reg import c:\source\odbc\oil-and-gas-system-odbc.reg *>&1 | Out-Null}

    
    }

else {Write-Warning "Computer is not accessable, please try later!"}