BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'Get-TeamViewerDeviceCustomField' {
    It 'Should get all device custom field values for a managed device' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod {
            @{ customFieldValues = @(
                    @{ fieldKeyId = '00000000-0000-0000-0000-000000000001'; value = 'AssetTag001' },
                    @{ fieldKeyId = '00000000-0000-0000-0000-000000000002'; value = 'SerialNumber123' }
                ) }
        }

        $Result = Get-TeamViewerDeviceCustomField -ApiToken $testApiToken -ManagedDeviceId 'd12345678'

        $Result.Count | Should -Be 2
        $Result[0].Value | Should -Be 'AssetTag001'
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomField'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and
            $Uri -eq '//unit.test/managed/devices/d12345678/custom-fields' -and
            $Method -eq 'Get'
        }
    }

    It 'Should accept pipeline input' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod {
            @{ customFieldValues = @(@{ fieldKeyId = '00000000-0000-0000-0000-000000000001'; value = 'Test' }) }
        }

        'd12345678' | Get-TeamViewerDeviceCustomField -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/managed/devices/d12345678/custom-fields'
        }
    }
}
