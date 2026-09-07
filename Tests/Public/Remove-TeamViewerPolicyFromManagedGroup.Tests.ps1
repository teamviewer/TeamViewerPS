BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerPolicyFromManagedGroup.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Remove-TeamViewerPolicyFromManagedGroup' {

    It 'Should call the correct API endpoint to remove a policy from the managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -APIToken $testAPIToken -Group $testGroupId -PolicyType TeamViewer

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/policy/remove" -and $Method -eq 'Put' }
    }

    It 'Should remove teamviewer policy from managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -APItoken $testAPIToken -Group $testGroupId -Policytype Teamviewer

        $mockargs.body | Should -Not -BeNullOrEmpty
        $Body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $Body.policy_type | Should -Be 1
    }

    It 'Should remove monitoring policy from managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -APItoken $testAPIToken -Group $testGroupId -PolicyType Monitoring

        $mockargs.body | Should -Not -BeNullOrEmpty
        $Body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $Body.policy_type | Should -Be 4
    }

    It 'Should remove patch management policy from managed group' {
        Remove-TeamViewerPolicyFromManagedGroup -APItoken $testAPIToken -Group $testGroupId -PolicyType PatchManagement

        $mockargs.body | Should -Not -BeNullOrEmpty
        $Body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $Body.policy_type | Should -Be 5
    }

    It 'Should throw an error when called with invalid policy type' {
        { Remove-TeamViewerPolicyFromManagedGroup -APIToken $testAPIToken -Group $testGroupId -PolicyType 2 } | Should -Throw
    }
}
