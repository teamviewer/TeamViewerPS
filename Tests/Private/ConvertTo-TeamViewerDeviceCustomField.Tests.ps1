BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerDeviceCustomField.ps1"
}

Describe 'ConvertTo-TeamViewerDeviceCustomField' {
    It 'Should map the API properties and type the result' {
        $InputObject = [PSCustomObject]@{
            fieldKeyId = '00000000-0000-0000-0000-000000000001'
            value      = 'AssetTag001'
        }

        $Result = $InputObject | ConvertTo-TeamViewerDeviceCustomField

        $Result.FieldKeyId | Should -Be '00000000-0000-0000-0000-000000000001'
        $Result.Value | Should -Be 'AssetTag001'
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomField'
        $Result.ToString() | Should -Be 'AssetTag001'
    }

    It 'Should convert multiple pipeline inputs' {
        $Results = @(
            [PSCustomObject]@{ fieldKeyId = 'id1'; value = 'Value1' }
            [PSCustomObject]@{ fieldKeyId = 'id2'; value = 'Value2' }
        ) | ConvertTo-TeamViewerDeviceCustomField

        $Results.Count | Should -Be 2
        $Results.Value | Should -Be @('Value1', 'Value2')
    }
}
