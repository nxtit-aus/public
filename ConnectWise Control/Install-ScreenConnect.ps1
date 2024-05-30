# ScreenConnect Install Wrapper for Intune
# James Vincent
# https://jamesvincent.co.uk/2024/02/07/how-to-deploy-screenconnect-using-intune/
# February 2024

param(
  [Parameter(Mandatory=$true)]
  [string]$Client,
  [Parameter(Mandatory=$true)]
  [string]$Domain,
  [Parameter(Mandatory=$false)]
  [string]$Department,
  [Parameter(Mandatory=$false)]
  [string]$DeviceType
)

# Check for Working Directory
$FolderPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Apps\ScreenConnect"
if (!(Test-Path $FolderPath)) {
  New-Item -ItemType Directory -Path $FolderPath
} else {
  write-host "$FolderPath already exists."
}

# .\Install-ScreenConnect.ps1 -Client "ClientName" -Department "No Consent" -DeviceType "No Consent"
# Install ScreenConnect
Invoke-WebRequest "https://$Domain.screenconnect.com/Bin/ScreenConnect.ClientSetup.msi?e=Access&y=Guest&c=$Client&c=&c=$Department&c=$DeviceType&c=&c=&c=&c=" -OutFile $FolderPath\ScreenConnect.msi

Start-Process "msiexec.exe" -ArgumentList "/i", "$env:ProgramData\Microsoft\IntuneManagementExtension\Apps\ScreenConnect\ScreenConnect.msi", "/qn", "/l*v", "`"$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\App-Install-ScreenConnect.log`"" -Wait

# Delete the ScreenConnect Installer
$FilePath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Apps\ScreenConnect\ScreenConnect.msi"
if (!(Test-Path $FilePath)) {
  write-host "$FilePath not found."
} else {
  Remove-Item -LiteralPath "$env:ProgramData\Microsoft\IntuneManagementExtension\Apps" -Force -Recurse
}

exit