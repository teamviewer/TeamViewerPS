BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $TestApiToken = [securestring]@{}
    $null = $TestApiToken
    $MockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $MockArgs.Body = $Body
        @{ id = 'g1234'; name = 'Unit Test Group' }
    }
}

Describe 'New-TeamViewerGroup' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerGroup -ApiToken $TestApiToken -Name 'Unit Test Group'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $TestApiToken -and $Uri -eq '//unit.test/groups' -and $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerGroup -ApiToken $TestApiToken -Name 'Unit Test Group'

        $MockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($MockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Unit Test Group'
    }

    It 'Should include the given policy in the request' {
        $PolicyId = '3a424b41-bd8b-4d22-9b06-7d4d79fdb85e'
        New-TeamViewerGroup -ApiToken $TestApiToken -Name 'Unit Test Group' -Policy $PolicyId

        $MockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($MockArgs.Body) | ConvertFrom-Json
        $Body.policy_id | Should -Be $PolicyId
    }

    It 'Should return a Group object' {
        $Result = New-TeamViewerGroup -ApiToken $TestApiToken -Name 'Unit Test Group'

        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Group'
    }

    It 'Should not invoke REST when WhatIf is used' {
        New-TeamViewerGroup -ApiToken $TestApiToken -Name 'Unit Test Group' -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
