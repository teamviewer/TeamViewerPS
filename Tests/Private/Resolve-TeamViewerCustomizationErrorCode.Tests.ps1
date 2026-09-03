BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerCustomizationErrorCode.ps1')
}

Describe 'Resolve-TeamViewerCustomizationErrorCode' {
    It 'Returns known message for success code 0' {
        Resolve-TeamViewerCustomizationErrorCode -exitCode 0 | Should -Be 'Operation successful'
    }

    It 'Returns known message for defined error code' {
        Resolve-TeamViewerCustomizationErrorCode -exitCode 503 | Should -Be 'Invalid Module'
    }

    It 'Returns fallback message for unknown code' {
        Resolve-TeamViewerCustomizationErrorCode -exitCode 999 | Should -BeLike 'Unexpected error code: 999*'
    }
}
