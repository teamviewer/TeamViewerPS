BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerPolicyFromManagedGroup.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Remove-TeamViewerPolicyFromManagedGroup' {

    It 'Should call the correct API endpoint to remove a policy from the managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -ApiToken $testApiToken -Group $testGroupId -PolicyType TeamViewer
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/policy/remove" -And `
                $Method -eq 'Put' }
    }

    It 'Should remove teamviewer policy from managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -Apitoken $testApiToken -Group $testGroupId -Policytype Teamviewer
        $mockargs.body | Should -Not -BeNullOrEmpty
        $body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $body.policy_type | Should -Be 1
    }

    It 'Should remove monitoring policy from managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -Apitoken $testApiToken -Group $testGroupId -PolicyType Monitoring
        $mockargs.body | Should -Not -BeNullOrEmpty
        $body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $body.policy_type | Should -Be 4
    }

    It 'Should remove patch management policy from managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -Apitoken $testApiToken -Group $testGroupId -PolicyType PatchManagement
        $mockargs.body | Should -Not -BeNullOrEmpty
        $body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $body.policy_type | Should -Be 5
    }

    It 'Should throw an error when called with invalid policy type' {
        { Remove-TeamViewerPolicyFromManagedGroup `
                -ApiToken $testApiToken `
                -Group $testGroupId -PolicyType 2 } | Should -Throw
    }
}
