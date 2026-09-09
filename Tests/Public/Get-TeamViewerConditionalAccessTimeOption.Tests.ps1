BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerConditionalAccessTimeOption.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{ options = @(@{ optionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'; name = 'Option'; data = @{ start = '09:00'; end = '17:00' } }); continuation_token = $null } }
}

Describe 'Get-TeamViewerConditionalAccessTimeOption' {
    It 'Lists time options from the correct endpoint' {
        $Result = Get-TeamViewerConditionalAccessTimeOption -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/ConditionalAccess/Options/Time' -and $Method -eq 'Get'
        }
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConditionalAccessTimeOption'
    }

    It 'Uses the Options continuationToken query parameter' {
        Mock Invoke-TeamViewerRestMethod { @{ options = @(); continuation_token = 'next token' } } -ParameterFilter { $Uri -eq '//unit.test/ConditionalAccess/Options/Time' }
        Mock Invoke-TeamViewerRestMethod { @{ options = @(); continuation_token = $null } } -ParameterFilter { $Uri -match 'continuationToken=next%20token' }

        Get-TeamViewerConditionalAccessTimeOption -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter { $Uri -match 'continuationToken=next%20token' }
    }
}
