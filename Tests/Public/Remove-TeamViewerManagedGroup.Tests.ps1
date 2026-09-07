BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerManagedGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '6878ab59-5b19-4c7f-9afc-c1c07b0bfb7c'
    $null = $testGroupId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerGroup' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Group'; Alias = 'Id' }
            @{ Param = 'Group'; Alias = 'GroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroup' }
        ) {
            (Get-Command -Name Remove-TeamViewerManagedGroup).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerManagedGroup -APIToken $testAPIToken -Id $testGroupId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId" -and $Method -eq 'Delete' }
    }

    It 'Should accept ManagedGroup objects' {
        $testGroup = @{ id = $testGroupId } | ConvertTo-TeamViewerManagedGroup

        Remove-TeamViewerManagedGroup -APIToken $testAPIToken -Group $testGroup

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId" -and $Method -eq 'Delete' }
    }

    It 'Should fail for invalid group identifiers' {
        { Remove-TeamViewerManagedGroup -APIToken $testAPIToken -Group 1234 } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testGroup = @{ id = $testGroupId } | ConvertTo-TeamViewerManagedGroup
        $testGroup | Remove-TeamViewerManagedGroup -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId" -and $Method -eq 'Delete' }
    }
}
