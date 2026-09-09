BeforeAll {
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerConditionalAccessRule.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    $Script:RequestBody = $null
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $Script:RequestBody = $Body }
}

Describe 'Set-TeamViewerConditionalAccessRule' {
    It 'Updates a rule with the documented JSON body' {
        $RuleProperty = @{ comment = 'Updated comment' }
        Set-TeamViewerConditionalAccessRule -APIToken $TestAPIToken -RuleId 'rule-1' -Property $RuleProperty | Out-Null

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/ConditionalAccess/Rules/rule-1' -and $Method -eq 'Put'
        }
        $Request = [System.Text.Encoding]::UTF8.GetString($Script:RequestBody) | ConvertFrom-Json
        $Request.comment | Should -Be 'Updated comment'
    }
}
