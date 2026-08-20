BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-DateTime.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerDeviceCustomField.ps1"
}

Describe 'ConvertTo-TeamViewerDeviceCustomField' {
    It 'Should map the API properties and type the result' {
        $InputObject = [PSCustomObject]@{
            id         = '00000000-0000-0000-0000-000000000002'
            fieldKeyId = '00000000-0000-0000-0000-000000000001'
            value      = 'AssetTag001'
            createdAt  = '2026-01-01T00:00:00Z'
            updatedAt  = '2026-01-02T00:00:00Z'
        }

        $Result = $InputObject | ConvertTo-TeamViewerDeviceCustomField

        $Result.Id | Should -Be '00000000-0000-0000-0000-000000000002'
        $Result.Field_Id | Should -Be '00000000-0000-0000-0000-000000000001'
        $Result.Value | Should -Be 'AssetTag001'
        $Result.CreatedAt | Should -BeOfType ([datetime])
        $Result.UpdatedAt | Should -BeOfType ([datetime])
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomField'
    }

    It 'Should convert multiple pipeline inputs' {
        $Results = @(
            [PSCustomObject]@{ id = 'id1'; fieldKeyId = 'field1'; value = 'Value1' }
            [PSCustomObject]@{ id = 'id2'; fieldKeyId = 'field2'; value = 'Value2' }
        ) | ConvertTo-TeamViewerDeviceCustomField

        $Results.Count | Should -Be 2
        $Results.Value | Should -Be @('Value1', 'Value2')
        $Results.Field_Id | Should -Be @('field1', 'field2')
    }
}
