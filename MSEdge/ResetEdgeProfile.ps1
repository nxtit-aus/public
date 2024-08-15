$EdgeCheck = Test-Path -Path $Env:USERPROFILE\EdgeReset.file
if ($EdgeCheck -eq $false)
{
#Delete Edge Data
Remove-Item -Path "$Env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data" -Recurse
#Created File to avoid reset again
New-Item -Name EdgeReset.file -Path $Env:USERPROFILE
}
else 
{
#No Action Required. EdgeReset.file Exists.
exit
}