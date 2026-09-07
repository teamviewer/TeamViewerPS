BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerManagedGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        New-TeamViewerManagedGroup -APIToken $testAPIToken -Name 'Unit Test ManagedGroup'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/managed/groups' -and $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerManagedGroup -APIToken $testAPIToken -Name 'Unit Test ManagedGroup'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Unit Test ManagedGroup'
    }

    It 'Should return a ManagedGroup object' {
        $Result = New-TeamViewerManagedGroup -APIToken $testAPIToken -Name 'Unit Test ManagedGroup'
        $Result | Should -Not -BeNullOrEmpty
        $Result | Should -BeOfType ([pscustomobject])
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
    }
}
