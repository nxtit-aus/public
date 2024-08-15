# Modified for use as login script. Orginally from https://community.spiceworks.com/t/deleting-contents-of-signature-folder/555769/3
$TopFolder = 'C:\Users'
$SigFolder = 'AppData\Roaming\Microsoft\Signatures'

# Get the current user's folder
$CurrentUserFolder = Join-Path -Path $TopFolder -ChildPath $env:USERNAME

# Check if the Signatures folder exists for the current user
if (Test-Path (Join-Path -Path $CurrentUserFolder -ChildPath $SigFolder))
{
    $compPath = Join-Path -Path $CurrentUserFolder -ChildPath $SigFolder
    Remove-Item $compPath -Recurse 
}
