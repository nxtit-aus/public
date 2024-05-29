#intune intunewin file Uninstall
$Program = Get-WmiObject -class Win32_Product | Where-Object {$_.Name -like "Adobe Acrobat Reader 2020*"}
msiexec.exe /x $program.IdentifyingNumber /passive /quiet /norestart | Write-Verbose