# Scans computers and attempts to pull attached monitor serial numbers.

cls
write-output "**** Get Monitor Serial# ****"
write-output ""
$computers = read-host -prompt "Enter Computer(s)"
$computers = $computers.Split(",")
#foreach ($computer in $computers) #gc c:\batchfiles\floyd-dpp-tablets.txt)

foreach ($computer in $computers) #gc c:\batchfiles\johnson_training_lab.txt)



    {
        #$computer = Read-host -prompt "Computer "
        invoke-command -cn $computer -filepath "c:\batchfiles\getmoninfo.ps1" -ErrorAction SilentlyContinue
    }