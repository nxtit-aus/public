#=============================================================================================================================
#
# Script Name:     Intune-Remediation-Detection.ps1
# Description:     Checking for ltsvr errors via log or service disabled
# Notes:           Mainly used to fix agents that have failed.
#
#=============================================================================================================================

# Define Variables
$lterrorcheck = Select-String -Pattern "Unexpected exception occurred when initializing setting cryptography: System.Exception: Unable to initialize remote agent security.","UNCompress Error: Index was outside the bounds of the array" -Path "C:\Windows\LTSvc\LTErrors.txt"
$ltServiceDisableCheck = Get-Service "LTService" | Where-Object {$_.StartType -eq "Disabled"}

try
{
    if ($lterrorcheck.count -gt 5)
    {
        #The Above Strings have been located in the Logs for CW Automate
        Write-Host "Match for error from log"
        Return $lterrorcheck.count

        exit 1
    }
    elseif ($ltServiceDisableCheck -eq $true) 
    {
        #The service has been detected as disabled
        Write-Host "Match for service disabled"
        Return Get-Service "LTService" 

        exit 1
    }
    else
    {
        #Nothing Found
        Write-Host "No Issue Found"        
        exit 0
    }   
}
catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}