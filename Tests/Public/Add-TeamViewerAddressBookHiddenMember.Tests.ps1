BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerAddressBookHiddenMember.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerJsonRestMethod { }
}

Describe 'Add-TeamViewerAddressBookHiddenMember' {
    It 'Should call the correct API endpoint' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken -User 'account123'

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/companyaddressbook/hiddenmembers' -and $Method -eq 'Post' }
    }

    It 'Should add a single account to hidden members' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken -User 'account123'

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body | ConvertFrom-Json | Select-Object -ExpandProperty accountIds | Should -Contain 'account123'
            $true
        }
    }

    It 'Should accept multiple accounts via pipeline' {
        'account1', 'account2', 'account3' | Add-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            $body = $Body | ConvertFrom-Json
            $body.accountIds -contains 'account1' -and $body.accountIds -contains 'account2' -and $body.accountIds -contains 'account3'
        }
    }

    It 'Should batch operations at 100 accounts' {
        $accounts = 1..150 | ForEach-Object { "account$_" }
        $accounts | Add-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 2 -Scope It
    }

    It 'Should respect ShouldProcess' {
        { Add-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken -User 'account123' -WhatIf } | Should -Not -Throw
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 0 -Scope It
    }
}
