BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerGroup' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerGroup -APIToken $testAPIToken -Group 'g1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups/g1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept group objects' {
        $testGroup = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup

        Remove-TeamViewerGroup -APIToken $testAPIToken -Group $testGroup

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups/g1234' -and $Method -eq 'Delete' }
    }

    It 'Should fail for invalid group identifiers' {
        { Remove-TeamViewerGroup -APIToken $testAPIToken -Group 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testGroup = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup
        $testGroup | Remove-TeamViewerGroup -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups/g1234' -and $Method -eq 'Delete' }
    }
}
