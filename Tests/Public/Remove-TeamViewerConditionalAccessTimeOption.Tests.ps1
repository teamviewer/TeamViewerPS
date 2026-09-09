BeforeAll {
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerConditionalAccessTimeOption.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerConditionalAccessTimeOption' {
    It 'Deletes a time option with the documented API endpoint' {
        $TimeOptionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'

        Remove-TeamViewerConditionalAccessTimeOption -APIToken $TestAPIToken -TimeOptionId $TimeOptionId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "//unit.test/ConditionalAccess/Options/Time/$TimeOptionId" -and $Method -eq 'Delete'
        }
    }
}
