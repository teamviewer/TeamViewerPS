BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Get-TeamViewerContact.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            contacts = @(
                @{ contact_id = 'c1234'; name = 'test contact 1' },
                @{ contact_id = 'c4567'; name = 'test contact 2' },
                @{ contact_id = 'c8901'; name = 'test contact 3' }
            )
        } }
}

Describe 'Get-TeamViewerContact' {
    It 'Should call the correct API endpoint to list contacts' {
        Get-TeamViewerContact -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/contacts' -And `
                $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single contact' {
        Get-TeamViewerContact -ApiToken $testApiToken -Id 'c1234'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/contacts/c1234' -And `
                $Method -eq 'Get' }
    }

    It 'Should return Contact objects' {
        $result = Get-TeamViewerContact -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Contact'
    }

    It 'Should allow to filter by partial name' {
        Get-TeamViewerContact -ApiToken $testApiToken -Name 'TestName'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['name'] -eq 'TestName' }
    }

    It 'Should allow to filter by online state' {
        Get-TeamViewerContact -ApiToken $testApiToken -FilterOnlineState 'Busy'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['online_state'] -eq 'busy' }
    }
}
