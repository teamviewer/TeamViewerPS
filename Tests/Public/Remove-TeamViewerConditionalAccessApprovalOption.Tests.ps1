BeforeAll {
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerConditionalAccessApprovalOption.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerConditionalAccessApprovalOption' {
    It 'Deletes an approval option with the documented API endpoint' {
        $ApprovalOptionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'

        Remove-TeamViewerConditionalAccessApprovalOption -APIToken $TestAPIToken -ApprovalOptionId $ApprovalOptionId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "//unit.test/ConditionalAccess/Options/Approval/$ApprovalOptionId" -and $Method -eq 'Delete'
        }
    }
}
