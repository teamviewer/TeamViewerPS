BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerManagedGroup.ps1')
}

Describe 'ConvertTo-TeamViewerManagedGroup' {
    It 'Returns an object for pipeline input' {
        $InputObject = [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'Sample'; policy_id = 'none' }

        $Result = $InputObject | & ConvertTo-TeamViewerManagedGroup

        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.ManagedGroup'
    }

    It 'Supports pipeline processing of multiple items' {
        $InputObjects = @(
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'One' },
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'Two' }
        )

        $Result = $InputObjects | & ConvertTo-TeamViewerManagedGroup

        @($Result).Count | Should -Be 2
    }
}
