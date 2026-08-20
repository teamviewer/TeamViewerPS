BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'Set-TeamViewerDeviceCustomField' {
    It 'Should set a device custom field value' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod {
            @{ fieldKeyId = '00000000-0000-0000-0000-000000000001'; value = 'AssetTag001' }
        }

        $Result = Set-TeamViewerDeviceCustomField -ApiToken $testApiToken -ManagedDeviceId 'd12345678' -FieldConfigurationId '00000000-0000-0000-0000-000000000001' -Value 'AssetTag001'

        $Result.Value | Should -Be 'AssetTag001'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/managed/devices/d12345678/custom-fields/00000000-0000-0000-0000-000000000001' -and
            $Method -eq 'Post' -and
            (([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).value -eq 'AssetTag001')
        }
    }

    It 'Should not call the API with WhatIf' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod { }

        Set-TeamViewerDeviceCustomField -ApiToken $testApiToken -ManagedDeviceId 'd12345678' -FieldConfigurationId '00000000-0000-0000-0000-000000000001' -Value 'Test' -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
