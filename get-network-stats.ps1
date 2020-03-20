# Get Network Card Stats
cls
$computers = ""
write-output "**** Get Network Stats ****"
$computers = read-host "Enter Computer names or IP addresses"
$computers = $computers.split(",")

write-output ""

write-output "Getting network information on computer: $computer..."

        foreach ($computer in $computers)
        
        {
            Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $computer -filter ipenabled=true |select-object -property `
            IPaddress,DefaultIPGateway, ipsubnet, winsprimaryserver, winssecondaryserver, DNSServerSearchOrder 
        }