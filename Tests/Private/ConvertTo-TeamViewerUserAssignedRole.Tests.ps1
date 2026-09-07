BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerUserAssignedRole.ps1')
}

Describe 'ConvertTo-TeamViewerUserAssignedRole' {
    It 'Creates TeamViewerPS.UserAssignedRole object' {
        $Result = 'f37001f9-bc3e-452e-9533-d81b0916be09' | ConvertTo-TeamViewerUserAssignedRole

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.UserAssignedRole'
        $Result.Role_Id | Should -Be 'f37001f9-bc3e-452e-9533-d81b0916be09'
    }
}
