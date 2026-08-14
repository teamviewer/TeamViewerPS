BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'Set-TeamViewerDeviceCustomField' {
    It 'Should update a device custom field definition' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod {
            @{ fieldKeyId = '00000000-0000-0000-0000-000000000001'; fieldKey = 'AssetTag'; fieldType = 'string' }
        }

        $result = Set-TeamViewerDeviceCustomField -ApiToken $testApiToken -Id '00000000-0000-0000-0000-000000000001' -FieldKey 'AssetTag'

        $result.FieldKey | Should -Be 'AssetTag'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/device-custom-fields/00000000-0000-0000-0000-000000000001' -and
            $Method -eq 'Put' -and
            (([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).fieldKey -eq 'AssetTag')
        }
    }

    It 'Should reject an invalid field ID' {
        { Set-TeamViewerDeviceCustomField -ApiToken $testApiToken -Id 'invalid' -FieldKey 'AssetTag' } | Should -Throw
    }
}
