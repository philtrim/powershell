# Script that runs on a group of computers used to Map general drives as needed
# Written by Phillip Trimble, COT.  Last used: 7/3/2019
# 
# cmd /C "msiexec /i `"$FGFileLocation\FormsGen_50_Setup.msi`" /qn" | Out-Null
# 

cls
write-output "**** Drive Mapping Script ****"
$user = 'eas\eas-phillip.trimble'
$password = read-host -Prompt "Enter your password " -Assecurestring
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
write-output ""
write-output "Processing started." 
write-output ""

$startup = "ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$desktop = "Users\Public\Desktop\"
$drive = read-host -prompt "Enter Drive Letter i.e. (F:) "
$share = Read-Host "Enter full path of share to map i.e. (\\server\share) "

&psexec.exe  \\$computer -s -u $user -p $decodedpassword net use $drive delete
&psexec.exe  \\$computer -s -u $user -p $decodedpassword net use $drive $share /persistent:yes

