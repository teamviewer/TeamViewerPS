BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDeviceCustomFieldConfiguration.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'Get-TeamViewerDeviceCustomFieldConfiguration' {
    It 'Should list device custom field definitions' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod {
            @{ resources = @(@{ fieldKeyId = 'id1'; fieldKey = 'AssetTag'; fieldType = 'string' }) }
        }

        $Result = Get-TeamViewerDeviceCustomFieldConfiguration -ApiToken $testApiToken

        $Result.Name | Should -Be 'AssetTag'
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomFieldConfiguration'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and
            $Uri -eq '//unit.test/device-custom-fields' -and
            $Method -eq 'Get'
        }
    }
}
