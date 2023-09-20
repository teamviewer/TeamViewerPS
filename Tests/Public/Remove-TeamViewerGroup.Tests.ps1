BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Remove-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerGroup' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups/g1234' -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept group objects' {
        $testGroup = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup
        Remove-TeamViewerGroup -ApiToken $testApiToken -Group $testGroup

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups/g1234' -And `
                $Method -eq 'Delete' }
    }

    It 'Should fail for invalid group identifiers' {
        { Remove-TeamViewerGroup -ApiToken $testApiToken -Group 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testGroup = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup
        $testGroup | Remove-TeamViewerGroup -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups/g1234' -And `
                $Method -eq 'Delete' }
    }
}
