BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Test-TeamViewer32on64.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Get-TeamViewerRegKeyPath.ps1')
}

Describe 'Get-TeamViewerRegKeyPath' {
    It 'Returns WOW6432 path when variant is WOW6432' {
        Get-TeamViewerRegKeyPath -Variant WOW6432 | Should -Be 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
    }

    It 'Returns default path when variant is Auto and Test-TeamViewer32on64 is false' {
        Mock -CommandName Test-TeamViewer32on64 -MockWith { $false }

        Get-TeamViewerRegKeyPath -Variant Auto | Should -Be 'HKLM:\SOFTWARE\TeamViewer'
    }

    It 'Returns WOW6432 path when variant is Auto and Test-TeamViewer32on64 is true' {
        Mock -CommandName Test-TeamViewer32on64 -MockWith { $true }

        Get-TeamViewerRegKeyPath -Variant Auto | Should -Be 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
    }
}
