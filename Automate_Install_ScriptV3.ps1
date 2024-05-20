[CmdletBinding()]
Param (
    #[Parameter(Mandatory = $True)]
    #[String]$LTServer,
    [Parameter(Mandatory = $True)]
    [String]$LocID,
    [Parameter(Mandatory = $True)]
    [String]$Token
)
Start-Transcript -Path "C:\Windows\Temp\Ltinstall.log" -Append

#Hardcoded for now...
$LTServer = "https://nxtit.hostedrmm.com"

#Run script in 64bit PowerShell to enumerate correct path for pnputil
If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Try {
        &"$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCOMMANDPATH -Server $LTServer -LTPass $LTPass -Locataion $LocID 
    }
    Catch {
        Write-Error "Failed to start $PSCOMMANDPATH"
        Write-Warning "$($_.Exception.Message)"
        $Throwbad = $True
    }
}

function LabtechInstall {
    Invoke-Expression (new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/nxtit-aus/LabTech-Powershell-Module/master/LabTech.psm1'); Install-LTService -Server $LTServer -InstallerToken $Token -LocationID $LocID -Force
}

#Enable TLS, TLS1.1, TLS1.2, TLS1.3 in this session if they are available
IF([Net.SecurityProtocolType]::Tls) {[Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls}
IF([Net.SecurityProtocolType]::Tls11) {[Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls11}
IF([Net.SecurityProtocolType]::Tls12) {[Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12}
IF([Net.SecurityProtocolType]::Tls13) {[Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls13}

#Check on existing install to see if its working correctly

#$lterrorcheck = Select-String -Pattern "Unexpected exception occurred when initializing setting cryptography: System.Exception: Unable to initialize remote agent security." -Path "C:\Temp\LTErrors-B00039.txt"
$lterrorcheck = Select-String -Pattern "Unexpected exception occurred when initializing setting cryptography: System.Exception: Unable to initialize remote agent security.","UNCompress Error: Index was outside the bounds of the array" -Path "C:\Windows\LTSvc\LTErrors.txt"
$ltServiceDisableCheck = Get-Service "LTService" | Where-Object {$_.StartType -eq "Disabled"}
$lterrorcheck.Count

#check for ltsvc
$ltsvcCheck = Test-Path -Path C:\Windows\ltsvc\LTSVC.exe

if ($ltsvcCheck -eq $True)
{
    If ($lterrorcheck.count -gt 20)
    {
    Write-Host "Automate Agent detected but appears to be in a failed state. Forcing re-install"
    LabtechInstall 
    }
    elseif ($null -ne $ltServiceDisableCheck) 
    {
    Write-Host "Automate Agent detected but appears to have been disabled. Forcing re-install"
    LabtechInstall 
    }
    else 
    {
    Write-Host "Automate Agent detected and does not appear to be in a failed state. Validate in Automate."
    }
}
else 
{
    Write-Host "Automate Agent not detected. Installing..."
    LabtechInstall
}
Stop-Transcript