BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'Get-TeamViewerDeviceCustomField' {
    It 'Should list device custom field definitions' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod {
            @{ resources = @(@{ fieldKeyId = 'id1'; fieldKey = 'AssetTag'; fieldType = 'string' }) }
        }

        $Result = Get-TeamViewerDeviceCustomField -ApiToken $testApiToken

        $Result.FieldKey | Should -Be 'AssetTag'
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomField'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and
            $Uri -eq '//unit.test/device-custom-fields' -and
            $Method -eq 'Get'
        }
    }
}
