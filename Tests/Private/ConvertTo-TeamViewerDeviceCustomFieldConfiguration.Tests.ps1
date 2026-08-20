BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-DateTime.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerDeviceCustomFieldConfiguration.ps1"
}

Describe 'ConvertTo-TeamViewerDeviceCustomFieldConfiguration' {
    It 'Should map the API properties and type the result' {
        $InputObject = [PSCustomObject]@{
            fieldKeyId  = '00000000-0000-0000-0000-000000000001'
            fieldKey    = 'AssetTag'
            fieldType   = 'string'
            description = 'Device asset tag'
            createdAt   = '2026-01-01T00:00:00Z'
            updatedAt   = '2026-01-02T00:00:00Z'
        }

        $Result = $InputObject | ConvertTo-TeamViewerDeviceCustomFieldConfiguration

        $Result.Id | Should -Be $InputObject.fieldKeyId
        $Result.Key | Should -Be 'AssetTag'
        $Result.Type | Should -Be 'string'
        $Result.Description | Should -Be 'Device asset tag'
        $Result.CreatedAt | Should -BeOfType ([datetime])
        $Result.CreatedAt | Should -Be ([datetime]'2026-01-01T00:00:00Z')
        $Result.UpdatedAt | Should -BeOfType ([datetime])
        $Result.UpdatedAt | Should -Be ([datetime]'2026-01-02T00:00:00Z')
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomFieldConfiguration'
    }

    It 'Should convert multiple pipeline inputs' {
        $Results = @(
            [PSCustomObject]@{ fieldKeyId = 'id1'; fieldKey = 'One' }
            [PSCustomObject]@{ fieldKeyId = 'id2'; fieldKey = 'Two' }
        ) | ConvertTo-TeamViewerDeviceCustomFieldConfiguration

        $Results.Count | Should -Be 2
        $Results.Key | Should -Be @('One', 'Two')
    }
}
