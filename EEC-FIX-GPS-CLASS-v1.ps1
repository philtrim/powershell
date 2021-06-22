# Script to register the GPS software class.
cls
write-host "**** EEC GPS CLASS FIX ****"
$computer = read-host "Enter computer"

#robocopy "\\172.16.42.3\deploy\eec\SQL-OILGAS Database\DOG_clsGPS_Fix\GuppyGPSx32" "\\$computer\c$\Windows\Microsoft.NET\Framework\v4.0.30319" gpsreader.dll /IS
robocopy "\\172.16.42.3\deploy\eec\SQL-OILGAS Database\DOG_clsGPS_Fix\GuppyGPSx32" "\\$computer\c$\O&G Databases" gpsreader.dll /IS
invoke-command -cn $computer {& cmd /c C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm "c:\O&G Databases\gpsreader.dll" /tlb /codebase}
#robocopy "\\$computer\c$\Windows\Microsoft.NET\Framework\v4.0.30319" "\\$computer\c$\O&G Databases" gpsreader.* /IS

#robocopy "\\172.16.42.3\deploy\eec\SQL-OILGAS Database\DOG_clsGPS_Fix\clsGPS" "\\$computer\c$\Windows\Microsoft.NET\Framework\v4.0.30319" clsGPS.dll /IS
robocopy "\\172.16.42.3\deploy\eec\SQL-OILGAS Database\DOG_clsGPS_Fix\GuppyGPSx32" "\\$computer\c$\O&G Databases" clsGPS.dll /IS
invoke-command -cn $computer {& cmd /c C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm "c:\O&G Databases\clsGPS.dll" /tlb /codebase}
#robocopy "\\$computer\c$\Windows\Microsoft.NET\Framework\v4.0.30319" "\\$computer\c$\O&G Databases" clsGPS.* /IS



pause