#Set Properties
$root = '\\contoso.local\shares' #Share root
$identity = "CONTOSO\auditreview" #Group to provision Access
$fileSystemRights = "Read"
$type = "Allow"

#Create ACL
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList

#Decalre variable
[int]$count = 0
#Declare Array
$touchedFolders = new-object system.collections.arraylist

#Set start time
$starttime = Get-Date

Get-ChildItem -Path $root -Directory -Recurse | ForEach-Object {
    $folder = $_
    Write-Host $folder.FullName
    if ((($folder | Get-ACL).Access | Where-Object IdentityReference -eq $identity).IsInherited) {} else {
        Write-Host $folder.FullName
        if (($folder | Get-ACL).Access | Where-Object IdentityReference -eq $identity) {} else {
            $NewAcl = Get-Acl -Path $folder.FullName
            $NewAcl.SetAccessRule($fileSystemAccessRule)
            Set-Acl -Path $folder.FullName -AclObject $NewAcl

            $filepath = $file.fullname
            $acl = (Get-Item $filepath).GetAccessControl("access")
            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Group, "Write", "None", "None", "Deny")
            $acl.AddAccessRule($AccessRule)
            (Get-Item $FilePath).SetAccessControl($acl)

            $touchedFolders.Add(($folder.FullName)) > $null
            $count++
        }
    }
}

$endtime = Get-Date

for ($i=0; $i -le $count; $i++) {
    Write-Host -ForegroundColor Red $touchedFolders[$i]
}

Write-Host Start Time: $starttime
Write-Host End Time: $endtime