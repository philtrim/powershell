* Find and clear all CACHED Credentials leading to lockouts...
cls
write-output "**** Find and clear cached credentials ***"
$computer = read-host "Enter Computer Name"


& psexec \\$computer -i -s -d cmd.exe 

# rundll32 keymgr.dll,KRShowKeyMgr

#rundll32 keymgr.dll,KRShowKeyMgr
#Remove any items that appear in the list of Stored User Names and Passwords. Restart the computer.