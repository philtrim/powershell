# Gets the System Event log from the Martin Co DL Computer
cls
write-output "**** Get Event Log ****"
invoke-command -cn CIRIZDCZL7R22.kyfd01.ds.ky.gov {get-eventlog system -Message "*l1*" -EntryType Error -newest 25 | Format-Table -Wrap}