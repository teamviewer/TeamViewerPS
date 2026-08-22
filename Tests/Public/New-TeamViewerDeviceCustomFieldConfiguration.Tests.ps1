BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerDeviceCustomFieldConfiguration.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
}

Describe 'New-TeamViewerDeviceCustomFieldConfiguration' {
    It 'Should create a device custom field definition' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod {
            @{ fieldKeyId = 'id1'; fieldKey = 'AssetTag'; fieldType = 'string'; description = 'Device asset tag' }
        }

        $Result = New-TeamViewerDeviceCustomFieldConfiguration -ApiToken $testApiToken -FieldKey 'AssetTag' -Description 'Device asset tag'

        $Result.Name | Should -Be 'AssetTag'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/device-custom-fields' -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json; charset=utf-8' -and
            (([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).fieldKey -eq 'AssetTag') -and
            (([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).description -eq 'Device asset tag')
        }
    }

    It 'Should not call the API with WhatIf' {
        Mock Get-TeamViewerApiUri { '//unit.test' }
        Mock Invoke-TeamViewerRestMethod { }

        New-TeamViewerDeviceCustomFieldConfiguration -ApiToken $testApiToken -FieldKey 'AssetTag' -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
