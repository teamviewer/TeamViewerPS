BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerConditionalAccessRule.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{ rules = @(@{ ruleId = 'rule-1'; sourceId = 'source'; sourceType = 0; targetId = 'target'; targetType = 1; state = 0; expirations = @() }); continuation_token = $null } }
}

Describe 'Get-TeamViewerConditionalAccessRule' {
    It 'Lists rules from the correct endpoint' {
        $Result = Get-TeamViewerConditionalAccessRule -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/ConditionalAccess/Rules' -and $Method -eq 'Get'
        }
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConditionalAccessRule'
    }

    It 'Uses the Rules continuation_token query parameter' {
        Mock Invoke-TeamViewerRestMethod { @{ rules = @(); continuation_token = 'next token' } } -ParameterFilter { $Uri -eq '//unit.test/ConditionalAccess/Rules' }
        Mock Invoke-TeamViewerRestMethod { @{ rules = @(); continuation_token = $null } } -ParameterFilter { $Uri -match 'continuation_token=next%20token' }

        Get-TeamViewerConditionalAccessRule -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter { $Uri -match 'continuation_token=next%20token' }
    }
}
