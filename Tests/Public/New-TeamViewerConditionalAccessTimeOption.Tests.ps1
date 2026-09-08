BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerConditionalAccessTimeOption.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    $Script:RequestBody = $null
    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $Script:RequestBody = $Body; @{ optionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'; name = 'Office Hours'; data = @{ start = '09:00'; end = '17:00' } } }
}

Describe 'New-TeamViewerConditionalAccessTimeOption' {
    It 'Creates a time option with the documented JSON body' {
        New-TeamViewerConditionalAccessTimeOption -APIToken $TestAPIToken -Name 'Office Hours' -Data @{ start = '09:00'; end = '17:00' } | Out-Null

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/ConditionalAccess/Options/Time' -and $Method -eq 'Post'
        }
        $Request = [System.Text.Encoding]::UTF8.GetString($Script:RequestBody) | ConvertFrom-Json
        $Request.name | Should -Be 'Office Hours'
        $Request.data.start | Should -Be '09:00'
        $Request.data.end | Should -Be '17:00'
    }
}
