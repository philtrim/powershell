# Get SAS License Report
# Used for view inf SAS log reports for SAS 9.4 License updates
# Designed and written by Phillip Trimble, COT. 9/29/20 - Updated 12/01/20
cls
write-output "**** SAS Checking SETINIT Log Files ****"
remove-item "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\updated.txt" -force -erroraction silentlycontinue
remove-item "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\not-updated.txt" -force -erroraction silentlycontinue
remove-item "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\no-logfile.txt" -force -erroraction silentlycontinue
remove-item "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\offline.txt" -force -erroraction silentlycontinue
$logstream = 'Expiration:   30JUN2021.'

$computers = get-content "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\sascomputers-original.txt"
#$computers = read-host "Computer"
foreach ($computer in $computers)
{

   if (test-path \\$computer\c$ -erroraction silentlycontinue)
    
    {     
     $logfile = Invoke-Command -cn $computer {Get-Childitem "c:\Program Files\" -recurse -filter "setinit.log"} -erroraction silentlycontinue
     $logdir = $logfile | select-object directory | where-object {$_.directory -like "*9.4*"}
     $logdir = ($logdir.directory)

     if ($logfile)
     
       {
       
         $trimlogfile = $logdir -replace (":","$")
         $logdata = get-content "\\$computer\$trimlogfile\setinit.log" -erroraction silentlycontinue | select-string $logstream
     
          if ($logdata)
            {
             write-output "$computer log file contains--> $logstream"
             $computer | out-file "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\updated.txt" -append
            }
          
          else  
            {
             $computer | out-file "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\not-updated.txt" -append
            }

                     
        }
      
      else
        
        {
         
         $computer | out-file "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\no-logfile.txt" -append

        }

    } # end test path computer


    else {
          write-warning "$computer not available"
          $computer | out-file "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\offline.txt" -append

         }

       
 } #end first foreach

 $updated = (get-content \\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\updated.txt -erroraction silentlycontinue | measure-object -line).lines 
 $notupdated = (get-content \\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\not-updated.txt -erroraction silentlycontinue | measure-object -line).lines
 $nologfile = (get-content \\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\no-logfile.txt -erroraction silentlycontinue | measure-object -line).lines
 $offline = (get-content \\eas.ds.ky.gov\dfs\ds_share\efs-d2\sas\offline.txt -erroraction silentlycontinue | measure-object -line).lines

 write-output "Updated = $updated"
 write-output "Not Updated = $notupdated"
 write-output "No Log File = $nologfile"
 write-output "Offline = $offline"
 # end program