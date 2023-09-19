function Add-Registry {
    param (
        [Microsoft.Win32.RegistryKey]$RegKey,
        [string]$Program
    )

    #CustomObject including all information for each registry and sub keys
    $retRegKey = [PSCustomObject]@{
        Program      = $Program
        RegistryPath = $RegKey.Name
        Entries      = @()
    }
    Write-Output "Collecting registry data $($retRegKey.RegistryPath)"
    foreach ($valueName in $RegKey.GetValueNames()) {
        $value = $RegKey.GetValue($valueName)
        $type, $value = Get-TypeAndValueOfRegistryValue -RegKey $RegKey -ValueName $valueName
        $blackList = @('BuddyLoginTokenAES', 'BuddyLoginTokenSecretAES', 'Certificate', 'CertificateKey', 'CertificateKeyProtected',
            'MultiPwdMgmtPwdData', 'PermanentPassword', 'PK', 'SecurityPasswordAES', 'SK', 'SRPPasswordMachineIdentifier')
        foreach ($blackListValue in $blackList) {
            if ($valueName -eq $blackListValue) {
                $value = '___PRIVATE___'
            }
        }
        $entry = [PSCustomObject]@{
            Name  = $valueName
            Value = $value
            Type  = $type
        }
        $retRegKey.Entries += $entry
    }

    foreach ($subKeyName in $RegKey.GetSubKeyNames()) {
        $subKey = $RegKey.OpenSubKey($subKeyName)
        Add-Registry -RegKey $subKey -Program $subKeyName
    }
    #Adding CustomObject to array declared in Get-RegistryPaths
    $AllTVRegistryData.Add($retRegKey) | Out-Null
}


