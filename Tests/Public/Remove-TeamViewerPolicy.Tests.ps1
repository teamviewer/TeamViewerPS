BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerPolicy.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testPolicyId = '5fc4deaf-3789-4a83-a46a-a75864b71804'
    $null = $testPolicyId
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body; @{ id = 'u1234' } }
}

Describe 'Remove-TeamViewerPolicy' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerPolicy `
            -ApiToken $testApiToken `
            -PolicyId $testPolicyId
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept Policy objects' {
        $testPolicyObj = @{ policy_id = $testPolicyId } | ConvertTo-TeamViewerPolicy
        Remove-TeamViewerPolicy `
            -ApiToken $testApiToken `
            -Policy $testPolicyObj
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testPolicyObj = @{ policy_id = $testPolicyId } | ConvertTo-TeamViewerPolicy
        $testPolicyObj | Remove-TeamViewerPolicy -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -And `
                $Method -eq 'Delete' }
    }
}
