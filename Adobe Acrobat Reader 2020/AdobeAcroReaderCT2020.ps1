#Script to install Adobe Acrobat Reader 2020 Classic Track and Update 20.005.3063x Planned update, May 14, 2024

$baseInstallerUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/Acrobat2020/2000130002/AcroRdr20202000130002_MUI.exe"
$patchUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/Acrobat2020/2000530636/AcroRdr2020Upd2000530636_MUI.msp"

$baseInstallerPath = "C:\Windows\Temp\AcroRdr20202000130002_MUI.exe"
$patchPath = "C:\Windows\Temp\AcroRdr2020Upd2000530636_MUI.msp"

$ProgressPreference = 'SilentlyContinue'

Write-Host "Downloading Base Installer"
Invoke-WebRequest -Uri $baseInstallerUrl -OutFile $baseInstallerPath
Write-Host "Downloading Patch Installer"
Invoke-WebRequest -Uri $patchUrl -OutFile $patchPath

# Installation
Write-Host "Starting Installation of Base Installer"
Start-Process -FilePath $baseInstallerPath -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES" -Wait
Write-Host "Finished Installation of Base Installer"
Write-Host "Starting Installation of May 2024 Patch"
Start-Process -FilePath "msiexec.exe" -ArgumentList "/p $patchPath /qn" -Wait -Verbose
Write-Host "Finished Installation of May 2024 Patch"

# Clean up
Write-Host "Removing Files"
Remove-Item -Path $baseInstallerPath, $patchPath -Force
Write-Host "Finshed Removing files"
