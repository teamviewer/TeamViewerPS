BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDeviceCustomFieldConfiguration.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
}

Describe 'Get-TeamViewerDeviceCustomFieldConfiguration' {
    It 'Should list device custom field definitions' {
        Mock Get-TeamViewerAPIUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod {
            @{ resources = @(@{ fieldKeyId = 'id1'; fieldKey = 'AssetTag'; fieldType = 'string' }) }
        }

        $Result = Get-TeamViewerDeviceCustomFieldConfiguration -APIToken $testAPIToken

        $Result.Name | Should -Be 'AssetTag'
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomFieldConfiguration'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and
            $Uri -eq '//unit.test/device-custom-fields' -and
            $Method -eq 'Get'
        }
    }
}
