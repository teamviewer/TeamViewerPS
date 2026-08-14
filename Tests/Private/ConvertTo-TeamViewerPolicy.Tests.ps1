BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerPolicy.ps1')
}

Describe 'ConvertTo-TeamViewerPolicy' {
    It 'Maps policy settings into key/value/enforce collection' {
        $inputObject = [pscustomobject]@{
            policy_id = 'p1'
            name = 'Policy'
            settings = @([pscustomobject]@{ key='k1'; value='v1'; enforce=$true })
        }

        $result = ConvertTo-TeamViewerPolicy -InputObject $inputObject

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Policy'
        $result.Settings.Count | Should -Be 1
        $result.Settings[0].Key | Should -Be 'k1'
    }
}
