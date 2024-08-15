# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All, Directory.ReadWrite.All"

# Get all users
$users = Get-MgUser -All

foreach ($user in $users) {
    # Remove Email methods
    $emailMethods = Get-MgUserAuthenticationEmailMethod -UserId $user.Id
    foreach ($method in $emailMethods) {
        Remove-MgUserAuthenticationEmailMethod -UserId $user.Id -EmailAuthenticationMethodId $method.Id
    }

    # Remove FIDO2 methods
    $fido2Methods = Get-MgUserAuthenticationFido2Method -UserId $user.Id
    foreach ($method in $fido2Methods) {
        Remove-MgUserAuthenticationFido2Method -UserId $user.Id -Fido2AuthenticationMethodId $method.Id
    }

    # Remove Microsoft Authenticator methods
    $microsoftAuthenticatorMethods = Get-MgUserAuthenticationMicrosoftAuthenticatorMethod -UserId $user.Id
    foreach ($method in $microsoftAuthenticatorMethods) {
        Remove-MgUserAuthenticationMicrosoftAuthenticatorMethod -UserId $user.Id -MicrosoftAuthenticatorAuthenticationMethodId $method.Id
    }

    # Remove Phone methods
    $phoneMethods = Get-MgUserAuthenticationPhoneMethod -UserId $user.Id
    foreach ($method in $phoneMethods) {
        Remove-MgUserAuthenticationPhoneMethod -UserId $user.Id -PhoneAuthenticationMethodId $method.Id
    }

    # Remove Software OATH methods
    $softwareOathMethods = Get-MgUserAuthenticationSoftwareOathMethod -UserId $user.Id
    foreach ($method in $softwareOathMethods) {
        Remove-MgUserAuthenticationSoftwareOathMethod -UserId $user.Id -SoftwareOathAuthenticationMethodId $method.Id
    }

    # Remove Windows Hello for Business methods
    $windowsHelloMethods = Get-MgUserAuthenticationWindowsHelloForBusinessMethod -UserId $user.Id
    foreach ($method in $windowsHelloMethods) {
        Remove-MgUserAuthenticationWindowsHelloMethod -UserId $user.Id -WindowsHelloForBusinessAuthenticationMethodId $method.Id
    }
}

# Disconnect from Microsoft Graph
# Disconnect-MgGraph
