BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Remove-TeamViewerManagedGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '6878ab59-5b19-4c7f-9afc-c1c07b0bfb7c'
    $null = $testGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerGroup' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerManagedGroup -ApiToken $testApiToken -Id $testGroupId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept ManagedGroup objects' {
        $testGroup = @{ id = $testGroupId } | ConvertTo-TeamViewerManagedGroup
        Remove-TeamViewerManagedGroup -ApiToken $testApiToken -Group $testGroup

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should fail for invalid group identifiers' {
        { Remove-TeamViewerManagedGroup -ApiToken $testApiToken -Group 1234 } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testGroup = @{ id = $testGroupId } | ConvertTo-TeamViewerManagedGroup
        $testGroup | Remove-TeamViewerManagedGroup -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId" -And `
                $Method -eq 'Delete' }
    }
}
