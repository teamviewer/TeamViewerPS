BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'New-TeamViewerDeviceCustomField' {
    It 'Should create a device custom field definition' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod {
            @{ fieldKeyId = 'id1'; fieldKey = 'AssetTag'; fieldType = 'string'; description = 'Device asset tag' }
        }

        $result = New-TeamViewerDeviceCustomField -ApiToken $testApiToken -FieldKey 'AssetTag' -Description 'Device asset tag'

        $result.FieldKey | Should -Be 'AssetTag'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/device-custom-fields' -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json; charset=utf-8' -and
            (([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).fieldKey -eq 'AssetTag') -and
            (([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).description -eq 'Device asset tag')
        }
    }
}
