BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerConditionalAccessApprovalOption.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{ options = @(@{ optionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'; name = 'Option'; data = @{ controlComputer = 0 } }); continuation_token = $null } }
}

Describe 'Get-TeamViewerConditionalAccessApprovalOption' {
    It 'Lists approval options from the correct endpoint' {
        $Result = Get-TeamViewerConditionalAccessApprovalOption -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/ConditionalAccess/Options/Approval' -and $Method -eq 'Get'
        }
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConditionalAccessApprovalOption'
    }

    It 'Uses the Options continuationToken query parameter' {
        Mock Invoke-TeamViewerRestMethod { @{ options = @(); continuation_token = 'next token' } } -ParameterFilter { $Uri -eq '//unit.test/ConditionalAccess/Options/Approval' }
        Mock Invoke-TeamViewerRestMethod { @{ options = @(); continuation_token = $null } } -ParameterFilter { $Uri -match 'continuationToken=next%20token' }

        Get-TeamViewerConditionalAccessApprovalOption -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter { $Uri -match 'continuationToken=next%20token' }
    }
}
