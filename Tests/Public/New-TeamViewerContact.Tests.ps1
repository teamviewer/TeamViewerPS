BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerContact.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id      = 'c1234'
            name    = 'Test Contact 1'
            groupid = 'g5678'
        }
    }
}

Describe 'New-TeamViewerContact' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group 'g5678'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/contacts' -and $Method -eq 'Post' }
    }

    It 'Should include the given input parameters in the request' {
        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group 'g5678'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.email | Should -Be 'unit@example.test'
        $Body.groupid | Should -Be 'g5678'
    }

    It 'Should accept Group objects' {
        $testGroupObj = @{ id = 'g5678' } | ConvertTo-TeamViewerGroup

        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group $testGroupObj

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.email | Should -Be 'unit@example.test'
        $Body.groupid | Should -Be 'g5678'
    }

    It 'Should include an invitation in the request when requested' {
        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group 'g5678' -Invite

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.invite | Should -BeTrue
    }

    It 'Should return a Contact object' {
        $Result = New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group 'g5678'

        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Contact'
    }

    It 'Should not invoke REST when WhatIf is used' {
        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group 'g5678' -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
