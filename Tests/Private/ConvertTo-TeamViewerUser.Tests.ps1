BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerUser.ps1')
}

Describe 'ConvertTo-TeamViewerUser' {
    It 'Loads all properties by default' {
        $InputObject = [pscustomobject]@{ id='u1'; name='User'; email='u@example.com'; active=$true; last_access_date='2026-01-01'; tfa_enforcement='off'; tfa_enabled=$false; log_sessions=$true; show_comment_window=$false; sso_status='none' }

        $Result = ConvertTo-TeamViewerUser -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.User'
        $Result.PSObject.Properties.Name | Should -Contain 'Active'
        $Result.LastAccessDate | Should -BeOfType ([datetime])
        $Result.LastAccessDate | Should -Be ([datetime]'2026-01-01')
    }

    It 'Loads minimal property set when requested' {
        $InputObject = [pscustomobject]@{ id='u1'; name='User'; email='u@example.com'; active=$true }

        $Result = ConvertTo-TeamViewerUser -InputObject $InputObject -PropertiesToLoad Minimal

        $Result.PSObject.Properties.Name | Should -Not -Contain 'Active'
        $Result.Email | Should -Be 'u@example.com'
    }
}
