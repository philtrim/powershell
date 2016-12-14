rem Script to Install BlueZone and Formsgen, written by Phillip Trimble, COT
rem Last updated 12/13/16

cls
echo Begin Install...

"\\hfsro121-0581\deploy\BlueZone\Child Support files\BlueZone Desktop\setup.exe"
pause
"\\hfsro121-0581\deploy\BlueZone\Child Support files\formsgen.msi"
pause

copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\formsgen.exe" "c:\program files\formsgen\"
mkdir "c:\program files\formsgen\data"
copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\data\" "c:\program files\formsgen\data\"
copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\copy3\"*.* "C:\program files\bluezone"
copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\copy3\"*.* "C:\program files\bluezone\scripts\"
copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\mainframe.zmd" "C:\program files\BlueZone\config\"
copy "C:\Program Files\BlueZone\Config\mainframe.zmd" "C:\Users\Public\Desktop\"
copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\JCA\"jca.* "C:\Users\Public\Desktop\"
copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\JCA\3270_jca.pad" "C:\program files\BlueZone\"
copy "\\hfsro121-0581\deploy\BlueZone\Child Support files\mapit.bat" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
cls
notepad.exe "\\hfsro121-0581\deploy\BlueZone\Child Support files\edit_startup.txt"

