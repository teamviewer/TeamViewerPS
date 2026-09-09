BeforeAll {
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerConditionalAccessRule.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    $Script:RequestBody = $null
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $Script:RequestBody = $Body }
}

Describe 'Remove-TeamViewerConditionalAccessRule' {
    It 'Deletes a rule with the documented JSON body' {
        Remove-TeamViewerConditionalAccessRule -APIToken $TestAPIToken -RuleId 'rule-1' -ModificationReason 'No longer needed'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter { $Uri -eq '//unit.test/ConditionalAccess/Rules' -and $Method -eq 'Delete' }
        $Request = [System.Text.Encoding]::UTF8.GetString($Script:RequestBody) | ConvertFrom-Json
        $Request.id | Should -Be 'rule-1'
        $Request.modification_reason | Should -Be 'No longer needed'
    }
}
