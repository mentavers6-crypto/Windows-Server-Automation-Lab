# --- Partage IT (pour le groupe RH) ---
New-Item -Path "C:\PartageIT" -ItemType Directory
New-SmbShare -Name "partageIT" -Path "C:\PartageIT" -FullAccess "RH"
Grant-SmbShareAccess -Name "partageIT" -AccountName "RH" -AccessRight Full -Force

# --- Partage Gestion (pour le groupe DEV) ---
New-Item -Path "C:\PartageGestion" -ItemType Directory
New-SmbShare -Name "partageGestion" -Path "C:\PartageGestion" -FullAccess "DEV"
Grant-SmbShareAccess -Name "partageGestion" -AccountName "DEV" -AccessRight Full -Force