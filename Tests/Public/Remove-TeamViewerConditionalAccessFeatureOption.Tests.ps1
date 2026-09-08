BeforeAll {
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerConditionalAccessFeatureOption.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerConditionalAccessFeatureOption' {
    It 'Deletes a feature option with the documented API endpoint' {
        $FeatureOptionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'

        Remove-TeamViewerConditionalAccessFeatureOption -APIToken $TestAPIToken -FeatureOptionId $FeatureOptionId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "//unit.test/ConditionalAccess/Options/Features/$FeatureOptionId" -and $Method -eq 'Delete'
        }
    }
}
