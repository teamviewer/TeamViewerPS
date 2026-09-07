BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerContact.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerContact' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerContact -APIToken $testAPIToken -Id 'c1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/contacts/c1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept Contact objects' {
        $testContact = @{ contact_id = 'c1234' } | ConvertTo-TeamViewerContact

        Remove-TeamViewerContact -APIToken $testAPIToken -Contact $testContact

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/contacts/c1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testContact = @{ contact_id = 'c1234' } | ConvertTo-TeamViewerContact
        $testContact | Remove-TeamViewerContact -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/contacts/c1234' -and $Method -eq 'Delete' }
    }
}
