BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerPolicy.ps1')
}

Describe 'ConvertTo-TeamViewerPolicy' {
    It 'Maps policy settings into key/value/enforce collection' {
        $InputObject = [pscustomobject]@{
            policy_id = 'p1'
            name = 'Policy'
            settings = @([pscustomobject]@{ key='k1'; value='v1'; enforce=$true })
        }

        $Result = ConvertTo-TeamViewerPolicy -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Policy'
        $Result.Settings.Count | Should -Be 1
        $Result.Settings[0].Key | Should -Be 'k1'
    }
}
