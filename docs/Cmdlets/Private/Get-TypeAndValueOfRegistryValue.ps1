function Get-TypeAndValueOfRegistryValue {
    param (
        [Microsoft.Win32.RegistryKey]$RegKey,
        [string]$ValueName
    )

    $valueKind = $RegKey.GetValueKind($ValueName)
    $type = $valueKind

    if ($valueKind -eq 'DWord') {
        $type = "=dword:"
        $value = [Convert]::ToInt32($RegKey.GetValue($ValueName)).ToString('x')
    }
    elseif ($valueKind -eq 'Binary') {
        $type = "=hex:"
        $value = ($RegKey.GetValue($ValueName) | ForEach-Object { $_.ToString('x2') }) -join ','
    }
    elseif ($valueKind -eq 'String') {
        $type = "="
        $value = $RegKey.GetValue($ValueName).ToString()
    }
    elseif ($valueKind -eq 'MultiString') {
        $type = "=hex(7):"
        $value += ($RegKey.GetValue($ValueName) | ForEach-Object {
                $_.ToCharArray() | ForEach-Object { [Convert]::ToInt32($_).ToString('X') + ',00' }
            }) -join ','
        $value += ',00,00,'
        if ($value.Length -gt 0) {
            $value += '00,00'
        }
    }
    else {
        $type = ""
        $value = $RegKey.GetValue($ValueName).ToString()
    }

    return $type, $value
}

