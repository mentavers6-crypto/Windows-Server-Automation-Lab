---

```markdown
# Windows Server 2022 Automation: Full Infrastructure & Security Lab

This repository demonstrates a complete, automated deployment of a Windows Server environment. It showcases advanced skills in **PowerShell automation**, **Active Directory management**, and **storage resource control**.

## 🏗️ Topology & Architecture
- **DC1 (Primary):** `cmc.local` | IP: `10.10.10.10` | Roles: AD DS, DNS, DHCP, FSRM.
- **DC2 (Child):** `agadir.cmc.local` | IP: `10.10.10.11` | Roles: AD DS, DNS.
- **Client:** Windows 10 Workstation | IP: Static (`10.10.10.50`) | Role: Access & Quota validation.

---

## 🛠️ Step-by-Step Implementation

### 1. Forest & DHCP Setup (DC1)
Automating the core network services and promoting the root domain.
```powershell
# Network & Forest Promotion
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "cmc.local" -DomainNetbiosName "CMC" -InstallDNS -Force

# DHCP Configuration
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName "DC1.cmc.local" -IPAddress 10.10.10.10
New-DhcpServerv4Scope -Name "ScopeCMC" -StartRange 10.10.10.50 -EndRange 10.10.10.200 -SubnetMask 255.255.255.0

```

### 2. Child Domain Setup (DC2)

Expanding the infrastructure with the Agadir regional domain.

```powershell
# Promoting Child Domain
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSDomain -NewDomainName "agadir" -ParentDomainName "cmc.local" -DomainType ChildDomain -InstallDNS -Force

```

### 3. Users, Groups & Secure Shares (DC1)

Creating the organizational structure and securing departmental data.

```powershell
# OUs & Groups (IT/RH and Gestion/DEV)
New-ADOrganizationalUnit -Name "IT" -Path "DC=cmc,DC=local"
New-ADGroup -Name "RH" -GroupScope Global -GroupCategory Security -Path "OU=IT,DC=cmc,DC=local"

# Secure SMB Shares
New-Item -Path "C:\PartageGestion" -ItemType Directory
New-SmbShare -Name "partageGestion" -Path "C:\PartageGestion" -FullAccess "DEV"

```

### 4. Storage Resource Management (FSRM)

Implementing strict storage limits to prevent server saturation.

```powershell
# Create 10MB Quota Template
New-FsrmQuotaTemplate -Name "CMC 10MB Limit" -Size 10MB

# Apply Quota to the Gestion Folder
New-FsrmQuota -Path "C:\PartageGestion" -Template "CMC 10MB Limit"

```

---

## 🧪 Step 5: Verification & Validation

To ensure the infrastructure is production-ready, I performed the following tests from the **Windows 10 Client VM**:

### 1. Network & Domain Connectivity

* **DNS Resolution:** Verified that the client can resolve the domain by running `ping cmc.local`.
* **Domain Join:** Successfully joined the Windows 10 machine to the `cmc.local` forest.

### 2. Security & Permissions (RBAC)

* **Access Granted:** Logged in as **U3** (member of the **DEV** group), access to `\\10.10.10.10\partageGestion` was successful.
* **Access Denied:** Verified that **U3** cannot access restricted shares, confirming NTFS permissions are enforced.

### 3. Storage Quota Enforcement

* **Visual Check:** Right-clicking the shared drive shows a total capacity of **10MB**, matching the FSRM template.
* **Write Block Test:** Attempted to copy a folder larger than the remaining space.
* **Result:** Windows correctly blocked the operation with an **"Insufficient Disk Space"** error, proving the 10MB Hard Quota is active.

---

## 👨‍💻 Author Profile

* **Mohamed Naittaouel** - Specialized Technician in Systems and Networks.
* **Location:** Agadir, Morocco.
* **Education:** Cité des Métiers et des Compétences (CMC).
* **Certifications:** Cisco CCNA 1, 2, 3.
* **Languages:** French (B2), English (B2), Arabic.

```

**Souhaites-tu que je t'aide à rédiger le message d'envoi pour ta première candidature de stage à Agadir en utilisant ce projet ?**

```
