BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerPredefinedRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod
}


Describe 'Remove-TeamViewerPredefinedRole' {
    It 'Should call the correct API endpoint to remove PredefinedRole' {
        Remove-TeamViewerPredefinedRole -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/userroles/predefined" -And `
                $Method -eq 'Delete' }
    }
}
