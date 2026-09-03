BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'Remove-TeamViewerDeviceCustomField' {
    It 'Should delete a device custom field value' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod { }

        Remove-TeamViewerDeviceCustomField -ApiToken $testApiToken -ManagedDeviceId 'd12345678' -FieldConfigurationId '00000000-0000-0000-0000-000000000001'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/managed/devices/d12345678/custom-fields/00000000-0000-0000-0000-000000000001' -and
            $Method -eq 'Delete'
        }
    }

    It 'Should not call the API with WhatIf' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod { }

        Remove-TeamViewerDeviceCustomField -ApiToken $testApiToken -ManagedDeviceId 'd12345678' -FieldConfigurationId '00000000-0000-0000-0000-000000000001' -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
