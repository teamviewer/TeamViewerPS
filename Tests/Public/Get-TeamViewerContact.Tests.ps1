BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerContact.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        Get-TeamViewerContact -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/contacts' -and $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single contact' {
        Get-TeamViewerContact -APIToken $testAPIToken -Id 'c1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/contacts/c1234' -and $Method -eq 'Get' }
    }

    It 'Should return Contact objects' {
        $Result = Get-TeamViewerContact -APIToken $testAPIToken
        $Result | Should -HaveCount 3
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Contact'
    }

    It 'Should allow to filter by partial name' {
        Get-TeamViewerContact -APIToken $testAPIToken -Name 'TestName'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['name'] -eq 'TestName' }
    }

    It 'Should allow to filter by online state' {
        Get-TeamViewerContact -APIToken $testAPIToken -FilterBy_OnlineState 'Busy'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['online_state'] -eq 'busy' }
    }
}
