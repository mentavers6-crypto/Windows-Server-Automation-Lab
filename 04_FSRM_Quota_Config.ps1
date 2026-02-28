# 3. FSRM Quota Configuration

# Ensure FSRM feature is installed
Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools

# Create the 10MB Template
New-FsrmQuotaTemplate -Name "CMC 10MB Limit" -Size 10MB

# Apply Quota to the Gestion Folder
New-FsrmQuota -Path "C:\PartageGestion" -Template "CMC 10MB Limit"

Write-Host "File Server shares and 10MB Quota configured successfully!" -ForegroundColor Green