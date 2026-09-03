BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerAssignmentErrorCode.ps1')
}

Describe 'Resolve-TeamViewerAssignmentErrorCode' {
    It 'Returns known message for success code 0' {
        Resolve-TeamViewerAssignmentErrorCode -exitCode 0 | Should -Be 'Operation successful'
    }

    It 'Returns known message for defined error code' {
        Resolve-TeamViewerAssignmentErrorCode -exitCode 408 | Should -Be 'Denied by policy'
    }

    It 'Returns fallback message for unknown code' {
        Resolve-TeamViewerAssignmentErrorCode -exitCode 999 | Should -BeLike 'Unexpected error code: 999*'
    }
}
