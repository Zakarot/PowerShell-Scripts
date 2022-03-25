#Set Properties
$root = '\\contoso.local\shares\' #folder with broken permissions
$identity = "CONTOSO\auditreview" #Access Group to filter out of checks.

#Set start time
$starttime = Get-Date

Get-ChildItem -Path $root -Directory -Recurse | ForEach-Object {
    $folder = $_
    $acl = ($folder | Get-ACL).Access
    $inherits = $false
    $local = $false
    foreach ($permission in $acl) {
        if ($permission.IsInherited) {
            #folder inherits
            $inherits = $true
        } else {
            if ($permission.IdentityReference -eq $identity) {
                #Skipping $identity
            } else {
                #Non- $identity permission set locally
                $local = $true
            }
        }
    }
    if ($local) {
        if ($inherits) {
            #folder has both locally set and inherited permissions
            Write-Host $folder.FullName

            #Commands to break Inheritance and update the ACL: https://virot.eu/remove-ntfs-rights-inheritance-using-powershell/
            #$acl.SetAccessRuleProtection($True, $False)
            #Set-Acl -Path $folder.FullName -AclObject $acl

            #Alternate command to set ACL if above fails, but still needs tweaking before use
            #$folderFullName = $folder.fullname
            #$acl = (Get-Item $folderFullName).GetAccessControl("access")
            #$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Group, "Write", "None", "None", "Deny")
            #$acl.AddAccessRule($AccessRule)
            #(Get-Item $folderFullName).SetAccessControl($acl)
        }
    }
}

$endtime = Get-Date

Write-Host Start Time: $starttime
Write-Host End Time: $endtime