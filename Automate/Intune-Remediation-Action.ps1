#=============================================================================================================================
#
# Script Name:     Intune-Remediation-Action.ps1
# Description:     Force re-install of CW Automate
# Notes:           Used in conjuction with "Intune-Remediation-Detection.ps1". Example usaged .\Intune-Remediation-Action.ps1 -LTServer "msp.hostedrmm.com" -LocID "001" -Token "InstallerTokenHere"
#
#=============================================================================================================================

## Raise toast to have user contact whoever is specified in the $msgText

# Define Variables
[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True)]
    [String]$LTServer,
    [Parameter(Mandatory = $True)]
    [String]$LocID,
    [Parameter(Mandatory = $True)]
    [String]$Token
)

# Main script

Invoke-Expression (new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/nxtit-aus/LabTech-Powershell-Module/master/LabTech.psm1'); Install-LTService -Server $LTServer -InstallerToken $Token -LocationID $LocID -Force