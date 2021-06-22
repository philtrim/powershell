# Install GEO Tools
cls
write-host "**** Installs GEOTOOLS for Div of Oil & Gas ****"
$computer = read-host "Enter computer"
robocopy "\\172.16.42.3\deploy\EEC\SQL-OILGAS Database\DOG\GeoTools" "\\$computer\c$\source\geotools" /e /np
\\172.16.42.3\deploy\psexec \\$computer -s c:\source\geotools\setup.exe /qn