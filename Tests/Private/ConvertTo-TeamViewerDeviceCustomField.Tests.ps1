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
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomField'
    }
}
