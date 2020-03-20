cls

write-output "**** Get AD User ****"

$uname = read-host "Enter User Name"
$DomainControllers = gc c:\batchfiles\dclist.txt

Foreach($DC in $DomainControllers)

 {
try {
        Get-ADUser -Identity $uname -Server $DC -Properties LockedOut,AccountLockoutTime,BadLogonCount,BadPwdCount,LastBadPasswordAttempt
        
    }
catch {continue}


}


