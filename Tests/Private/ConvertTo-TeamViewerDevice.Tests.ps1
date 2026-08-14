BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerDevice.ps1')
}

Describe 'ConvertTo-TeamViewerDevice' {
    It 'Returns an object for pipeline input' {
        $inputObject = [pscustomobject]@{ device_id = 'd1'; alias = 'Sample'; groupid = 'g1'; remotecontrol_id = 'r123'; description = 'desc'; online_state = 'Online'; assigned_to = $true }

        $result = $inputObject | & ConvertTo-TeamViewerDevice

        $result | Should -Not -BeNullOrEmpty
        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Device'
        $result.TeamViewerId | Should -Be '123'
    }

    It 'Supports pipeline processing of multiple items' {
        $inputObjects = @(
            [pscustomobject]@{ device_id = 'd1'; alias = 'One'; groupid = 'g1'; remotecontrol_id = 'r100' },
            [pscustomobject]@{ device_id = 'd2'; alias = 'Two'; groupid = 'g2'; remotecontrol_id = 'r200' }
        )

        $result = $inputObjects | & ConvertTo-TeamViewerDevice

        @($result).Count | Should -Be 2
    }
}
