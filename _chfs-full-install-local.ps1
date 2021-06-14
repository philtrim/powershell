if (!(net session)) {$path =  "& '" + $myinvocation.mycommand.definition + "'" ; Start-Process powershell -Verb runAs -ArgumentList $path ; exit}
cls
write-output "**** CHFS FS Full Install ****"

new-item -path "c:\" -name "Source" -Itemtype "directory" -Force
new-item -path "c:\source" -name "Install Files" -Itemtype "directory" -Force

function beep 
    {[console]::beep(3000,50), [console]::beep(2500,50), [console]::beep(2000,50), [console]::beep(1500,50),[console]::beep(2000,50),[console]::beep(2500,50),[console]::beep(3000,50) }

$source = "\\172.16.42.3\deploy\chfs\install files"
$dest = "c:\source\install files"
write-output "Copying Installer Files to local computer..."
robocopy $source $dest /e /np /R:0 /W:0

set-location $dest

cls

beep
$instid = read-host "Do you want to install KL, MAINFRAME, KDA and All Related Files (y/n)"


if ($instid -match "[yY]")
    {

    write-output "The following launches the Interactive Deployment Script to install KL, Mainframe, etc.."
    pause

    & "$dest\interactiveDeployment.ps1"
    }

start-sleep -seconds 5
cls

write-output "Installing KDA"
cmd /c "$dest\kdainstall\kda.setup.exe" /q
start-sleep -Seconds 5
msiexec /i "$dest\kdainstall\kda.setup.msi" /q
start-sleep -Seconds 5
write-output "Installing Wacom STU-SigCaptX"
cmd /c "$dest\wacom\chrome\Wacom-STU-SigCaptX-1_4_2.exe" /q NO_STU_CHECK=1 DRIVER=1
start-sleep -Seconds 5
write-output "Installing Wacom STU-Driver"
cmd /c "$dest\wacom\IE\Wacom-STU-Driver-5.4.5.exe" /s
start-sleep -Seconds 5
write-output "Installing Wacom STU-SDK"
msiexec /i "$dest\wacom\IE\Wacom-STU-SDK-2.1.1.msi" /q
start-sleep -Seconds 5
write-output "Installing KnowledgeLake Capture Extension"
robocopy "\\172.16.42.3\deploy\chfs\install files\knowledgelake\KnowledgeLake Capture Extension" "c:\source" KnowledgeLakeCaptureExtension.*
&cmd /c  regedit /s "c:\source\KnowledgeLakeCaptureExtension.reg"

cls


beep
$instpreq = read-host "Do you want to remaining prerequisites: GPVPN, VIP, Teams, Chrome, Firefox, Silverlight  (y/n)"

if ($instpreq -match "[yY]")

    {
    write-output "Installing Global Protect VPN"
    msiexec /i "$dest\GPVPN\GlobalProtect64.msi" /q PORTAL="secure.vpn.ky.gov"
    start-sleep -Seconds 5
    write-output "Installing MS Teams"
    msiexec /i "$dest\Teams\Teams_windows_x64.msi" /q
    start-sleep -Seconds 5
    write-output "Installing Firefox"
    msiexec /i "$dest\Firefox Setup 69.0.3.msi" /q
    start-sleep -Seconds 5
    write-output "Installing Chrome"
    cmd /c "$dest\ChromeSetup.exe" /silent /install
    start-sleep -Seconds 5
    write-output "Installing VIP"
    msiexec /i "$dest\vipsetup.msi" /q 
    start-sleep -Seconds 5
    write-output "Installing SilverLight"
    cmd /c "$dest\Silverlight_x64.exe" /q
    start-sleep -Seconds 5
    #write-output "Installing KDA"
    #cmd /c "$dest\kdainstall\kda.setup.exe" /q
    #start-sleep -Seconds 5
    #msiexec /i "$dest\kdainstall\kda.setup.msi" /q
    #start-sleep -Seconds 5
    write-output "Installing Wacom STU-SigCaptX"
    cmd /c "$dest\wacom\chrome\Wacom-STU-SigCaptX-1_4_2.exe" /q NO_STU_CHECK=1 DRIVER=1
    start-sleep -Seconds 5
    write-output "Installing Wacom STU-Driver"
    cmd /c "$dest\wacom\IE\Wacom-STU-Driver-5.4.5.exe" /s
    start-sleep -Seconds 5
    write-output "Installing Wacom STU-SDK"
    msiexec /i "$dest\wacom\IE\Wacom-STU-SDK-2.1.1.msi" /q
    start-sleep -Seconds 5
    write-output "Installing KnowledgeLake Capture Extension"
    robocopy "\\172.16.42.3\deploy\chfs\install files\knowledgelake\KnowledgeLake Capture Extension" "c:\source" KnowledgeLakeCaptureExtension.*
    &cmd /c  regedit /s "c:\source\KnowledgeLakeCaptureExtension.reg"
    }

cls
beep
$ic = read-host "Install Genesis Agent Client (formerly IC Client) (y/n)"

if ($ic -match "[yY]")
    {
    write-host "Installing Genesis Agent Client"
    Start-Process msiexec.exe -Wait -ArgumentList '/i "c:\source\Install Files\Genesys_R12020\Agent\ICUserApps_64bit_2020_R1.msi" /q /norestart'
    write-host "Installing Genesis Agent Client - Patch"
    Start-Process msiexec.exe -Wait -ArgumentList '/p "c:\source\Install Files\Genesys_R12020\Agent\ICUserApps_64bit_2020_R1_Patch7.msp" /q /norestart'
    write-host "Installing Genesis Agent Client - Customization Options"
    Start-Process msiexec.exe -Wait -ArgumentList '/i "c:\source\Install Files\Genesys_R12020\Agent\Genesys.Conduent.Customizations.Installer_4.19.99.0.msi" /q /norestart'
    write-host "Installing Genesis Agent Client - Supervisor Skill Add-In"
    Start-Process msiexec.exe -Wait -ArgumentList '/i "c:\source\Install Files\Genesys_R12020\Agent\Genesys.SkillTransferAddIn.Installer_1.8.54.0.msi" /q /norestart'
    write-host "Installing Genesis Agent Client - VSS Disconnect Button"
    Start-Process msiexec.exe -Wait -ArgumentList '/i "c:\source\Install Files\Genesys_R12020\Agent\ININ.VssDisconnectButton.Installer_1.1.13.0.msi" /q /norestart'
    }

beep
$icbm = read-host "Install Genesis Supervisor Agent Client (formerly ICBM) (y/n)"

if ($icbm -match "[yY]")
    {
    write-host "Installing Genesis Supervisor Agent Client"
    Start-Process msiexec.exe -Wait -ArgumentList '/i "c:\source\Install Files\Genesys_R12020\Supervisor\ICBusinessManagerApps_2020_R1.msi" /q /norestart'
    write-host "Installing Genesis Supervisor Client - Patch"
    Start-Process msiexec.exe -Wait -ArgumentList '/p "c:\source\Install Files\Genesys_R12020\Supervisor\ICBusinessManagerApps_2020_R1_Patch7.msp" /q /norestart'
    write-host "Installing Genesis Supervisor Client - Supervisor Skill Addin"
    Start-Process msiexec.exe -Wait -ArgumentList '/i "c:\source\Install Files\Genesys_R12020\Supervisor\Genesys.SupervisorSkillAddIn.Installer_1.7.90.0.msi" /q /norestart'
    write-host "Installing Genesis Supervisor Client - VSS Disconnect Button"
    Start-Process msiexec.exe -Wait -ArgumentList '/i "c:\source\Install Files\Genesys_R12020\Supervisor\ININ.VssDisconnectButton.Installer_1.1.13.0.msi" /q /norestart'
    
    }
  
write-output ""
write-output ""
write-output "Program complete!"
beep
pause