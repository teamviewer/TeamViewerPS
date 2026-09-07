BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerPolicy.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testPolicyId = '5fc4deaf-3789-4a83-a46a-a75864b71804'
    $null = $testPolicyId
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body; @{ id = 'u1234' } }
}

Describe 'Remove-TeamViewerPolicy' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Policy'; Alias = 'Id' }
            @{ Param = 'Policy'; Alias = 'PolicyId' }
        ) {
            (Get-Command -Name Remove-TeamViewerPolicy).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerPolicy -APIToken $testAPIToken -PolicyId $testPolicyId
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -and $Method -eq 'Delete' }
    }

    It 'Should accept Policy objects' {
        $testPolicyObj = @{ policy_id = $testPolicyId } | ConvertTo-TeamViewerPolicy

        Remove-TeamViewerPolicy -APIToken $testAPIToken -Policy $testPolicyObj
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -and $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testPolicyObj = @{ policy_id = $testPolicyId } | ConvertTo-TeamViewerPolicy
        $testPolicyObj | Remove-TeamViewerPolicy -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -and $Method -eq 'Delete' }
    }
}
