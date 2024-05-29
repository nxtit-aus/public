#intune intunewin file Install

$installScript = "https://raw.githubusercontent.com/nxtit-aus/public/main/Adobe%20Acrobat%20Reader%202020/AdobeAcroReaderCT2020.ps1"
$installScriptPath = "C:\Temp\AdobeAcroReaderCT2020.ps1"
$rootPath = "C:\Temp"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $rootPath)) {
    New-Item -ItemType Directory -Path (Split-Path -Path $rootPath)
}

Write-Host "Downloading Script"
Invoke-WebRequest -Uri $installScript -OutFile $installScriptPath

powershell.exe -executionpolicy bypass -windowstyle hidden -noninteractive -nologo -file $installScriptPath

Remove-Item -Path $installScriptPath -Force