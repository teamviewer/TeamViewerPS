BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerDeviceCustomField.ps1"
}

Describe 'ConvertTo-TeamViewerDeviceCustomField' {
    It 'Should map the API properties and type the result' {
        $inputObject = [PSCustomObject]@{
            fieldKeyId  = '00000000-0000-0000-0000-000000000001'
            fieldKey    = 'AssetTag'
            fieldType   = 'string'
            description = 'Device asset tag'
            createdAt   = '2026-01-01T00:00:00Z'
            updatedAt   = '2026-01-02T00:00:00Z'
        }

        $result = $inputObject | ConvertTo-TeamViewerDeviceCustomField

        $result.Id | Should -Be $inputObject.fieldKeyId
        $result.FieldKey | Should -Be 'AssetTag'
        $result.FieldType | Should -Be 'string'
        $result.Description | Should -Be 'Device asset tag'
        $result.CreatedAt | Should -Be '2026-01-01T00:00:00Z'
        $result.UpdatedAt | Should -Be '2026-01-02T00:00:00Z'
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomField'
        $result.ToString() | Should -Be 'AssetTag (00000000-0000-0000-0000-000000000001)'
    }

    It 'Should convert multiple pipeline inputs' {
        $results = @(
            [PSCustomObject]@{ fieldKeyId = 'id1'; fieldKey = 'One' }
            [PSCustomObject]@{ fieldKeyId = 'id2'; fieldKey = 'Two' }
        ) | ConvertTo-TeamViewerDeviceCustomField

        $results.Count | Should -Be 2
        $results.FieldKey | Should -Be @('One', 'Two')
    }
}
