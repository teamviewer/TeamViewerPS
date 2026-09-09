BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerConditionalAccessFeatureOption.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    $Script:RequestBody = $null
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $Script:RequestBody = $Body; @{ optionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'; name = 'Option'; data = @{ controlComputer = 0 } } }
}

Describe 'New-TeamViewerConditionalAccessFeatureOption' {
    It 'Posts the complete option model' {
        New-TeamViewerConditionalAccessFeatureOption -APIToken $TestAPIToken -Name 'Option' -Data @{ controlComputer = 0 } | Out-Null

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter { $Uri -eq '//unit.test/ConditionalAccess/Options/Features' -and $Method -eq 'Post' }
        $Request = [System.Text.Encoding]::UTF8.GetString($Script:RequestBody) | ConvertFrom-Json
        $Request.name | Should -Be 'Option'
        $Request.data.controlComputer | Should -Be 0
    }
}
