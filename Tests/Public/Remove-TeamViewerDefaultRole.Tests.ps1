BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerPredefinedRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod
}


Describe 'Remove-TeamViewerPredefinedRole' {
    It 'Should call the correct API endpoint to remove PredefinedRole' {
        Remove-TeamViewerPredefinedRole -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/userroles/predefined' -and $Method -eq 'Delete' }
    }
}
