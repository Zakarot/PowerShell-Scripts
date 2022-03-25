$data = Import-Csv -Path .\input.csv
foreach ($PC in $data) {
    Get-ADComputer $PC.PC | select DistinguishedName
}
