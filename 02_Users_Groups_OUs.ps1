# --- Création des Unités d'Organisation ---
New-ADOrganizationalUnit -Name "IT" -Path "DC=cmc,DC=local"
New-ADOrganizationalUnit -Name "gestion" -Path "DC=cmc,DC=local"

# --- Configuration de l'OU IT (Groupe RH) ---
New-ADGroup -Name "RH" -SamAccountName "RH" -GroupScope Global -GroupCategory Security -Path "OU=IT,DC=cmc,DC=local"

$secPassword = ConvertTo-SecureString "Admin123" -AsPlainText -Force
New-ADUser -Name "U1" -SamAccountName "U1" -UserPrincipalName "U1@cmc.local" -Path "OU=IT,DC=cmc,DC=local" -AccountPassword $secPassword -Enabled $true
New-ADUser -Name "U2" -SamAccountName "U2" -UserPrincipalName "U2@cmc.local" -Path "OU=IT,DC=cmc,DC=local" -AccountPassword $secPassword -Enabled $true

Add-ADGroupMember -Identity "RH" -Members "U1", "U2"

# --- Configuration de l'OU Gestion (Groupe DEV) ---
New-ADGroup -Name "DEV" -SamAccountName "DEV" -GroupScope Global -GroupCategory Security -Path "OU=gestion,DC=cmc,DC=local"

New-ADUser -Name "U3" -SamAccountName "U3" -UserPrincipalName "U3@cmc.local" -Path "OU=gestion,DC=cmc,DC=local" -AccountPassword $secPassword -Enabled $true
New-ADUser -Name "U4" -SamAccountName "U4" -UserPrincipalName "U4@cmc.local" -Path "OU=gestion,DC=cmc,DC=local" -AccountPassword $secPassword -Enabled $true

Add-ADGroupMember -Identity "DEV" -Members "U3", "U4"