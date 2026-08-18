BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerPolicyId.ps1')
}

Describe 'Resolve-TeamViewerPolicyId' {
    It 'Returns guid from TeamViewerPS.Policy object' {
        $Id = [guid]::NewGuid()
        $policy = [pscustomobject]@{ Id = $Id }
        $policy.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Policy')

        Resolve-TeamViewerPolicyId -Policy $policy | Should -Be $id
    }

    It 'Allows none when switch is set' {
        Resolve-TeamViewerPolicyId -Policy 'none' -AllowNone | Should -Be 'none'
    }

    It 'Allows inherit when switch is set' {
        Resolve-TeamViewerPolicyId -Policy 'inherit' -AllowInherit | Should -Be 'inherit'
    }

    It 'Converts guid string when no special switch applies' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerPolicyId -Policy $id.ToString() | Should -Be $id
    }
}
