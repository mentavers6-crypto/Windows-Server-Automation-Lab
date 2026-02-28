Windows Server 2022 Automation Lab: Full Infrastructure Deployment
This project demonstrates the automated deployment of a complete Windows Server environment, featuring a primary forest, a child domain, and secure client integration. Developed by Mohamed Naittaouel, Specialized Technician in Systems and Networks.

🏗️ Topology Architecture
DC1 (Root): cmc.local | IP: 10.10.10.10 | Roles: AD DS, DNS, DHCP.

DC2 (Child): agadir.cmc.local | IP: 10.10.10.11 | Roles: AD DS, DNS.

Client: Windows 10 Workstation | IP: Static (10.10.10.50) | Role: Access validation.

🛠️ Step 1: Root Domain Controller (DC1)
Configuring the core infrastructure on the primary server.

PowerShell
# 1. Network Interface Setup
New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress 10.10.10.10 -PrefixLength 24 -DefaultGateway 10.10.10.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 10.10.10.10, 8.8.8.8

# 2. AD DS Forest Promotion
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "cmc.local" -DomainNetbiosName "CMC" -InstallDNS -Force

# 3. DHCP Server Deployment
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName "DC1.cmc.local" -IPAddress 10.10.10.10
New-DhcpServerv4Scope -Name "ScopeCMC" -StartRange 10.10.10.50 -EndRange 10.10.10.200 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -ScopeId 10.10.10.0 -Router 10.10.10.1 -DnsServer 10.10.10.10 -DnsDomain "cmc.local"
Set-DhcpServerv4Scope -ScopeId 10.10.10.0 -State Active
🛠️ Step 2: Child Domain Controller (DC2)
Expanding the forest with a regional domain for Agadir.

PowerShell
# 1. Network Setup (DNS pointing to Parent DC1)
New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress 10.10.10.11 -PrefixLength 24 -DefaultGateway 10.10.10.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 10.10.10.10, 8.8.8.8

# 2. Child Domain Promotion
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSDomain -NewDomainName "agadir" -ParentDomainName "cmc.local" -DomainType ChildDomain -InstallDNS -Force
🛠️ Step 3: Organizational Unit & Security Management (DC1)
Automating the enterprise hierarchy and security groups.

PowerShell
# 1. Create OUs
New-ADOrganizationalUnit -Name "IT" -Path "DC=cmc,DC=local"
New-ADOrganizationalUnit -Name "gestion" -Path "DC=cmc,DC=local"

# 2. Security Groups & User Provisioning
$password = ConvertTo-SecureString "Admin123" -AsPlainText -Force

# IT / RH Department
New-ADGroup -Name "RH" -GroupScope Global -GroupCategory Security -Path "OU=IT,DC=cmc,DC=local"
New-ADUser -Name "U1" -SamAccountName "U1" -Path "OU=IT,DC=cmc,DC=local" -AccountPassword $password -Enabled $true
Add-ADGroupMember -Identity "RH" -Members "U1"

# Gestion / DEV Department
New-ADGroup -Name "DEV" -GroupScope Global -GroupCategory Security -Path "OU=gestion,DC=cmc,DC=local"
New-ADUser -Name "U3" -SamAccountName "U3" -Path "OU=gestion,DC=cmc,DC=local" -AccountPassword $password -Enabled $true
Add-ADGroupMember -Identity "DEV" -Members "U3"

# 3. Secure SMB Shares
New-Item -Path "C:\PartageIT" -ItemType Directory
New-SmbShare -Name "partageIT" -Path "C:\PartageIT" -FullAccess "RH"
New-Item -Path "C:\PartageGestion" -ItemType Directory
New-SmbShare -Name "partageGestion" -Path "C:\PartageGestion" -FullAccess "DEV"
🛠️ Step 4: Client Integration & Manual Configuration
Setting up the Windows 10 workstation manually to join the environment.

Static IP Configuration:

IP: 10.10.10.50

Mask: 255.255.255.0

Gateway: 10.10.10.1

DNS Server: 10.10.10.10 (Required for domain resolution)

Domain Join (PowerShell):

PowerShell
Add-Computer -DomainName "cmc.local" -Restart
🧪 Testing and Results
Validation of the security policy from the Client machine:

Logged in as U1 (RH Group): Access to \\10.10.10.10\partageIT is Granted.

Logged in as U1 (RH Group): Access to \\10.10.10.10\partageGestion is Denied (as intended).

👨‍💻 Author Information
Name: Mohamed Naittaouel

Location: Agadir, Morocco

Education: Cité des Métiers et des Compétences (CMC)

Certification: Cisco CCNA 1, 2, 3

Profile: Specialized Technician in Systems and Networks
