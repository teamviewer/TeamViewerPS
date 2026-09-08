BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerConditionalAccessRule.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    $Script:RequestBody = $null
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $Script:RequestBody = $Body; @{ ruleId = 'rule-1'; sourceId = 'source'; sourceType = 0; targetId = 'target'; targetType = 1; state = 0; expirations = @() } }
}

Describe 'New-TeamViewerConditionalAccessRule' {
    It 'Posts required source and target fields' {
        New-TeamViewerConditionalAccessRule -APIToken $TestAPIToken -SourceId 'source' -SourceType AccountId -TargetId 'target' -TargetType GroupId | Out-Null

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter { $Uri -eq '//unit.test/ConditionalAccess/Rules' -and $Method -eq 'Post' }
        $Request = [System.Text.Encoding]::UTF8.GetString($Script:RequestBody) | ConvertFrom-Json
        $Request.sourceType | Should -Be 0
        $Request.targetType | Should -Be 1
    }
}
