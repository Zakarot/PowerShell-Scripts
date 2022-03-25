#Bulk Migrate PCs to target OU based on inpush csv file

#csv sample:
##PC,OU
##DESKTOP1234,"OU=Some OU,OU=Computers,DC=contoso,DC=local"

$data = Import-Csv -Path .\input.csv
foreach ($PC in $data) {
    Get-ADComputer $PC.PC | Move-ADObject -TargetPath $PC.OU | Out-Null
}
Start-Sleep -s 5
foreach ($PC in $data) {
    Get-ADComputer $PC.PC | select DistinguishedName
}
