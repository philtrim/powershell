# SAS License Update #
# Used for updating SAS 9.4 Licenses
# Designed and written by Phillip Trimble, COT. 9/29/20
# Last updated 10/30/20

$license32 = 'SAS94_9CFXJZ_70006657_Win_Wrkstn.txt'
$license64 = 'SAS94_9CFXKZ_70108670_Win_X64_Wrkstn.txt'

$sasversion64 = ""
$sasversion32 = ""

cls
write-output "**** SAS License Update ****"
#$computers = get-content "\\172.16.42.3\deploy\sas\$source"
$computers =  read-host "Enter computer name"
foreach ($computer in $computers)

{
   if (test-path \\$computer\c$)
    
    {
     
     $sasinstalled = Get-WmiObject -Class Win32_Product -Computer $computer | select-object @{Name="ComputerName";Expression={$computer}}, Name, Version, InstallDate | where-object {$_.Name -like "SAS*"} 
     
      if ($sasinstalled)

         {
          write-output "SAS Install found"
          start-sleep -seconds 3
          write-output "Searching for existing logfiles and other required files.."
          $logfile =  @(invoke-command -cn $computer {get-childitem -path "c:\Program Files\sas*\" -Filter "setinit.log" -recurse})   
          $instloc = @(invoke-command -cn $computer {get-childitem -path "c:\Program Files" -Filter "SASRenew.exe" -recurse})
          $licenseloc = @(invoke-command -cn $computer {get-childitem -path "c:\Program Files\sas*\licenses" -Filter "*.txt" -recurse})
          $ninefourloc = @(invoke-command -cn $computer {get-childitem -path "c:\Program Files\sas*\" -Filter "9.4" -recurse})
          $licensedir = $licenseloc.Directory             
          $instdir=$instloc.directory
          $sasversion64 = $sasinstalled | Select-String '64'
          $sasversion32 = $sasinstalled | Select-String '32'
          
             
          if ($sasversion64)
        
                        {
                        write-output "$computer log file shows $computer is running the 64Bit version"
                        start-sleep -Seconds 2
                        write-output "Applying the 64Bit Version"
                        robocopy "\\172.16.42.3\deploy\sas\licenses" "\\$computer\c$\Program Files\sashome\licenses" "$license64" 
                        $licensefile = '-s "datafile:c:\program files\sashome\licenses\SAS94_9CFXKZ_70108670_Win_X64_Wrkstn.txt"'
                        \\172.16.42.3\deploy\psexec.exe -s -accepteula \\$computer "$instdir\SASRenew.exe" -s $licensefile    
          
                        #$trimlogfile = ($logfile.Directory) -replace (":","$")
                        #$logdata = get-content "\\$computer\$trimlogfile\setinit.log" | select-string 'W32_WKS' 
                        }
          
           if ($sasversion32)
                        
                        {
                        write-output "$computer log file shows $computer is running the 32Bit version"
                        start-sleep -Seconds 2
                        write-output "Applying the X86 Version"
                        robocopy "\\172.16.42.3\deploy\sas\licenses" "\\$computer\c$\program files\sashome\licenses" "$license32"
                        $licensefile = '-s "datafile:c:\program files\sashome\licenses\SAS94_9CFXJZ_70006657_Win_Wrkstn.txt"'
                        \\172.16.42.3\deploy\psexec.exe -s -accepteula \\$computer "$instdir\SASRenew.exe" -s "$licensefile"
                        }

                     

            write-output "Checking Log File for success"
            $logdata = get-content "\\$computer\$trimlogfile\setinit.log" | select-string 'AUG2020' 
            write-output "$logdata[0]"
        
       
    } # end SAS installed
         
         else 
            {
             write-warning "SAS Not Installed on $computer"
             start-sleep -seconds 2
             continue
             }


   } #end test path
    else {
          write-warning "$computer not available"
          start-sleep -seconds 3
          continue
         }
}#for each





