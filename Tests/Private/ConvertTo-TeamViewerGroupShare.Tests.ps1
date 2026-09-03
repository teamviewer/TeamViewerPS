BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerGroupShare.ps1')
}

Describe 'ConvertTo-TeamViewerGroupShare' {
    It 'Returns an object for pipeline input' {
        $InputObject = [pscustomobject]@{ id = 1; name = 'Sample'; accountId = 1; DomainId = [guid]::NewGuid().ToString(); DomainName = 'domain'; licenseId = [guid]::NewGuid().ToString(); PredefinedUserRoleId = 7; userid = 'u123'; roleId = 'r1'; roleName = 'role'; groupid='g1'; remotecontrol_id='r123'; userRoleId=[guid]::NewGuid().ToString(); policy_id=[guid]::NewGuid().ToString() }

        $Result = $InputObject | & ConvertTo-TeamViewerGroupShare

        $Result | Should -Not -BeNullOrEmpty
    }

    It 'Supports pipeline processing of multiple items' {
        $InputObjects = @(
            [pscustomobject]@{ id = 1; name = 'One'; accountId = 1; DomainId = [guid]::NewGuid().ToString(); DomainName='d1'; licenseId=[guid]::NewGuid().ToString(); PredefinedUserRoleId = 1; userid='u1'; roleId='r1'; roleName='role1'; groupid='g1'; remotecontrol_id='r100'; userRoleId=[guid]::NewGuid().ToString(); policy_id=[guid]::NewGuid().ToString() },
            [pscustomobject]@{ id = 2; name = 'Two'; accountId = 2; DomainId = [guid]::NewGuid().ToString(); DomainName='d2'; licenseId=[guid]::NewGuid().ToString(); PredefinedUserRoleId = 2; userid='u2'; roleId='r2'; roleName='role2'; groupid='g2'; remotecontrol_id='r200'; userRoleId=[guid]::NewGuid().ToString(); policy_id=[guid]::NewGuid().ToString() }
        )

        $Result = $InputObjects | & ConvertTo-TeamViewerGroupShare

        @($Result).Count | Should -Be 2
    }
}
