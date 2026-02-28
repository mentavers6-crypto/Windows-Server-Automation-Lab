
---

```markdown
# Windows Server 2022 Automation: Full Infrastructure Deployment

This project demonstrates the automated deployment of a Windows Server environment using PowerShell. It was developed by **Mohamed Naittaouel**, a Specialized Technician in Systems and Networks based in Agadir.

## 🏗️ Architecture Overview
The lab consists of a root domain (**cmc.local**) and a child domain (**agadir.cmc.local**).



---

## 🛠️ Implementation Steps & Commands

### 1. Network & Active Directory Core
First, we configure the static IP for **DC1** and promote it to a Domain Controller.

```powershell
# Network Configuration
New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress 10.10.10.10 -PrefixLength 24 -DefaultGateway 10.10.10.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 10.10.10.10, 8.8.8.8

# Forest Installation
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "cmc.local" -DomainNetbiosName "CMC" -InstallDNS -Force

```

### 2. DHCP Server Configuration

We automate the IP addressing for the local network.

```powershell
# Install and Authorize DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName "DC1.cmc.local" -IPAddress 10.10.10.10

# Create Scope
New-DhcpServerv4Scope -Name "ScopeCMC" -StartRange 10.10.10.50 -EndRange 10.10.10.200 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -ScopeId 10.10.10.0 -Router 10.10.10.1 -DnsServer 10.10.10.10 -DnsDomain "cmc.local"

```

### 3. OU, Groups, and Users

We create the organizational structure and security groups (**RH** for IT and **DEV** for Gestion).

```powershell
# OUs and Groups
New-ADOrganizationalUnit -Name "IT" -Path "DC=cmc,DC=local"
New-ADGroup -Name "RH" -GroupScope Global -GroupCategory Security -Path "OU=IT,DC=cmc,DC=local"

# User Creation (Example U1)
$pass = ConvertTo-SecureString "Admin123" -AsPlainText -Force
New-ADUser -Name "U1" -SamAccountName "U1" -Path "OU=IT,DC=cmc,DC=local" -AccountPassword $pass -Enabled $true
Add-ADGroupMember -Identity "RH" -Members "U1"

```

### 4. Secure File Sharing

We create shared folders with restricted permissions based on AD groups.

```powershell
# Create Directory and Share
New-Item -Path "C:\PartageIT" -ItemType Directory
New-SmbShare -Name "partageIT" -Path "C:\PartageIT" -FullAccess "RH"
Grant-SmbShareAccess -Name "partageIT" -AccountName "RH" -AccessRight Full -Force

```

---

## 🧪 Validation & Testing

To verify the security policy:

1. Log into a Windows 10 client as **U1** (member of **RH**).
2. Run `ping cmc.local` to verify DNS.
3. Access `\\10.10.10.10\partageIT` -> **Success**.
4. Access `\\10.10.10.10\partageGestion` -> **Access Denied**.

---

## 👨‍💻 About the Author

* **Name:** Mohamed Naittaouel
* **Role:** Specialized Technician in Systems and Networks
* **Education:** Cité des Métiers et des Compétences (CMC), Agadir
* **Certifications:** Cisco CCNA 1, 2, 3
* **Languages:** Arabic, French (B2), English (B2)

```

---

```
