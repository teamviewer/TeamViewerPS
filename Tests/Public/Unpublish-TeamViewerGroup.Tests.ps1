BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Unpublish-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Unpublish-TeamViewerGroup' {
    It 'Should call the correct API endpoint' {
        Unpublish-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234' -User 'u1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/groups/g1234/unshare_group' -and $Method -eq 'Post' }
    }

    It 'Should add all given users to the request' {
        Unpublish-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234' -User 'u1234', 'u4567', 'u8901'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.users | Should -Not -BeNullOrEmpty
        $Body.users | Should -HaveCount 3
        $Body.users | Should -Contain 'u1234'
        $Body.users | Should -Contain 'u4567'
        $Body.users | Should -Contain 'u8901'
        $Body.users | Should -Not -Contain 'foo' # counter-check
    }

    It 'Should accept Group object as input' {
        $testGroup = @{ id = 'g1234'; name = 'test group' } | ConvertTo-TeamViewerGroup

        Unpublish-TeamViewerGroup -ApiToken $testApiToken -Group $testGroup -User 'u1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/groups/g1234/unshare_group' -and $Method -eq 'Post' }
    }

    It 'Should accept User objects as input' {
        $testUser = @{ id = 'u1234'; name = 'testUser'; email = 'user@example.test' } | ConvertTo-TeamViewerUser

        Unpublish-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234' -User $testUser

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.users | Should -Not -BeNullOrEmpty
        $Body.users | Should -HaveCount 1
        $Body.users | Should -Contain 'u1234'
    }
}
