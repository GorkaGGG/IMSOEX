$domain = "DC=midominio,DC=com"

$ous = @("off1", "off2", "off3")
foreach ($ou in $ous) {
    New-ADOrganizationalUnit -Name $ou -Path $domain -ProtectedFromAccidentalDeletion:$false
}

New-ADUser -Name "off1user1" -SamAccountName "off1user1" -AccountPassword (ConvertTo-SecureString "Napstablook22" -AsPlainText -Force) -Enabled $true
Set-ADUser -Identity "off3user1" -ProfilePath "\\SERVIDOR2019\Perfiles\off1user1”

Move-ADObject (Get-ADUser off1user1).DistinguishedName -TargetPath "OU=off1,$domain"

for ($i = 1; $i -le 50; $i++) {
    $username = "off2user$i"
    New-ADUser -Name $username -SamAccountName $username -AccountPassword (ConvertTo-SecureString "Napstablook22" -AsPlainText -Force) -Enabled $true
    Move-ADObject (Get-ADUser $username).DistinguishedName -TargetPath "OU=off2,$domain"
Set-ADUser -Identity "off2user1" -ProfilePath "\\SERVIDOR2019\Perfiles\off2user$"
}

for ($i = 1; $i -le 30; $i++) {
    $username = "off3user$i"
    New-ADUser -Name $username -SamAccountName $username -AccountPassword (ConvertTo-SecureString "Napstablook22" -AsPlainText -Force) -Enabled $true
    Move-ADObject (Get-ADUser $username).DistinguishedName -TargetPath "OU=off3,$domain"
Set-ADUser -Identity "off3user1" -ProfilePath "\\SERVIDOR2019\Perfiles\off3user$”

}

foreach ($ou in $ous) {
    New-ADGroup -Name $ou -GroupScope Global -GroupCategory Security -Path "OU=$ou,$domain"
}

Add-ADGroupMember -Identity "off1" -Members "off1user1"

for ($i = 1; $i -le 50; $i++) {
    Add-ADGroupMember -Identity "off2" -Members "off2user$i"
}

for ($i = 1; $i -le 30; $i++) {
    Add-ADGroupMember -Identity "off3" -Members "off3user$i"
}
