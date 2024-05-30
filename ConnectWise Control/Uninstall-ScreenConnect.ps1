# ScreenConnect Install Wrapper for Intune
# James Vincent
# https://jamesvincent.co.uk/2024/02/07/how-to-deploy-screenconnect-using-intune/
# February 2024

# Define the application name
$applicationName = "ScreenConnect Client"

# Function to get the GUID from the uninstall string
function Get-GuidFromUninstallString($uninstallString) {
    $uninstallString -match '\{(.+?)\}' | Out-Null; $Matches[1]
}

# Search 64-bit registry
$uninstallKey64 = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -like "*$applicationName*" }

# Search 32-bit registry
$uninstallKey32 = Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -like "*$applicationName*" }

# Extract GUID from the uninstall string and if found, perform uninstall
if ($uninstallKey64) {
    $displayName = $uninstallKey64.DisplayName
    $guid64 = Get-GuidFromUninstallString $uninstallKey64.UninstallString
    #Write-Output "GUID for ${$displayName}: $guid64"
    # Display uninstall command
    Write-Output "Uninstalling $displayName."
    $uninstallLogFile = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\App-Uninstall-$displayName.log"
    # Run the uninstall command
    Start-Process "msiexec.exe" -ArgumentList "/x", "`"{$guid64}`"", "/qn", "/l*v", "`"$uninstallLogFile`"" -Wait
    Write-Output "$displayName has been uninstalled."
    exit 0
} elseif ($uninstallKey32) {
    $displayName = $uninstallKey32.DisplayName
    $guid32 = Get-GuidFromUninstallString $uninstallKey32.UninstallString
    #Write-Output "GUID for ${$displayName}: $guid32"
    # Display uninstall command
    Write-Output "Uninstalling $displayName."
    $uninstallLogFile = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\App-Uninstall-$displayName.log"
    # Run the uninstall command
    Start-Process "msiexec.exe" -ArgumentList "/x", "`"{$guid32}`"", "/qn", "/l*v", "`"$uninstallLogFile`"" -Wait
    Write-Output "$displayName has been uninstalled."
    exit 0
} else {
    Write-Output "Uninstallation of $displayName failed"
    exit 1
}