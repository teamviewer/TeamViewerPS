BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerManagedDevice.ps1')
}

Describe 'ConvertTo-TeamViewerManagedDevice' {
    It 'Returns an object for pipeline input' {
        $InputObject = [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'Sample'; TeamViewerId = '123'; isOnline = $true; teamviewerPolicyId = ([guid]::NewGuid().ToString()) }

        $Result = $InputObject | & ConvertTo-TeamViewerManagedDevice

        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.ManagedDevice'
    }

    It 'Supports pipeline processing of multiple items' {
        $InputObjects = @(
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'One'; TeamViewerId = '100'; isOnline = $true },
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'Two'; TeamViewerId = '200'; isOnline = $false }
        )

        $Result = $InputObjects | & ConvertTo-TeamViewerManagedDevice

        @($Result).Count | Should -Be 2
    }
}
