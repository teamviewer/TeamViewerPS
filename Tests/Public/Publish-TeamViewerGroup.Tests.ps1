BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Publish-TeamViewerGroup.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Publish-TeamViewerGroup' {

    It 'Should call the correct API endpoint' {
        Publish-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234' -User 'u1234' -Permissions 'readwrite'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/groups/g1234/share_group' -and $Method -eq 'Post' }
    }

    It 'Should add all given users to the request' {
        Publish-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234' -User 'u1234', 'u4567', 'u8901'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.users | Should -Not -BeNullOrEmpty
        $Body.users | Should -HaveCount 3
        $Body.users | Where-Object { $_.userid -eq 'u1234' } | Should -Not -BeNullOrEmpty
        $Body.users | Where-Object { $_.userid -eq 'u4567' } | Should -Not -BeNullOrEmpty
        $Body.users | Where-Object { $_.userid -eq 'u8901' } | Should -Not -BeNullOrEmpty
        $Body.users | Where-Object { $_.userid -eq 'foo' } | Should -BeNullOrEmpty  # counter-check
    }

    It 'Should accept Group object as input' {
        $testGroup = @{ id = 'g1234'; name = 'test group' } | ConvertTo-TeamViewerGroup

        Publish-TeamViewerGroup -ApiToken $testApiToken -Group $testGroup -User 'u1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/groups/g1234/share_group' -and $Method -eq 'Post' }
    }

    It 'Should accept User objects as input' {
        $testUser = @{ id = 'u1234'; name = 'testUser'; email = 'user@example.test' } | ConvertTo-TeamViewerUser

        Publish-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234' -User $testUser

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.users | Should -Not -BeNullOrEmpty
        $Body.users | Should -HaveCount 1
        $Body.users | Where-Object { $_.userid -eq 'u1234' } | Should -Not -BeNullOrEmpty
    }
}
