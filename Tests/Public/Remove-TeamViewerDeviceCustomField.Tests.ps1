BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'Remove-TeamViewerDeviceCustomField' {
    It 'Should delete a device custom field definition' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod { }

        Remove-TeamViewerDeviceCustomField -ApiToken $testApiToken -Id '00000000-0000-0000-0000-000000000001'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/device-custom-fields/00000000-0000-0000-0000-000000000001' -and
            $Method -eq 'Delete'
        }
    }

    It 'Should reject an invalid field ID' {
        { Remove-TeamViewerDeviceCustomField -ApiToken $testApiToken -Id 'invalid' } | Should -Throw
    }
}
