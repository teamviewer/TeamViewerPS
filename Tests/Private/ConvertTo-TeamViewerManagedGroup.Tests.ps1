BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerManagedGroup.ps1')
}

Describe 'ConvertTo-TeamViewerManagedGroup' {
    It 'Returns an object for pipeline input' {
        $inputObject = [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'Sample'; policy_id = 'none' }

        $result = $inputObject | & ConvertTo-TeamViewerManagedGroup

        $result | Should -Not -BeNullOrEmpty
        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.ManagedGroup'
    }

    It 'Supports pipeline processing of multiple items' {
        $inputObjects = @(
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'One' },
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'Two' }
        )

        $result = $inputObjects | & ConvertTo-TeamViewerManagedGroup

        @($result).Count | Should -Be 2
    }
}
