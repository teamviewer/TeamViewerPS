BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/New-TeamViewerManagedGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id   = 'b5b8c706-710d-43c5-b775-dc86347d9e56'
            name = 'Unit Test ManagedGroup'
        }
    }
}

Describe 'New-TeamViewerManagedGroup' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerManagedGroup -ApiToken $testApiToken -Name 'Unit Test ManagedGroup'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/managed/groups' -And `
                $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerManagedGroup -ApiToken $testApiToken -Name 'Unit Test ManagedGroup'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Unit Test ManagedGroup'
    }

    It 'Should return a ManagedGroup object' {
        $result = New-TeamViewerManagedGroup -ApiToken $testApiToken -Name 'Unit Test ManagedGroup'
        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
    }
}
