BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerUser.ps1')
}

Describe 'ConvertTo-TeamViewerUser' {
    It 'Loads all properties by default' {
        $inputObject = [pscustomobject]@{ id='u1'; name='User'; email='u@example.com'; active=$true; last_access_date='2026-01-01'; tfa_enforcement='off'; tfa_enabled=$false; log_sessions=$true; show_comment_window=$false; sso_status='none' }

        $result = ConvertTo-TeamViewerUser -InputObject $inputObject

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.User'
        $result.PSObject.Properties.Name | Should -Contain 'Active'
        $result.LastAccessDate | Should -BeOfType ([datetime])
        $result.LastAccessDate | Should -Be ([datetime]'2026-01-01')
    }

    It 'Loads minimal property set when requested' {
        $inputObject = [pscustomobject]@{ id='u1'; name='User'; email='u@example.com'; active=$true }

        $result = ConvertTo-TeamViewerUser -InputObject $inputObject -PropertiesToLoad Minimal

        $result.PSObject.Properties.Name | Should -Not -Contain 'Active'
        $result.Email | Should -Be 'u@example.com'
    }
}
