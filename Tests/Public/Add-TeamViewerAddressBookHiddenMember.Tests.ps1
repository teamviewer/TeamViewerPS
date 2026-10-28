BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerAddressBookHiddenMember.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerJsonRestMethod { }
    Mock Get-TeamViewerUser { [pscustomobject]@{ Id = 'u303950'; Email = 'user@example.com' } }
}

Describe 'Add-TeamViewerAddressBookHiddenMember' {
    It 'Should call the correct API endpoint' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User 303950

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $TestAPIToken -and $Uri -eq '//unit.test/companyaddressbook/hiddenmembers' -and $Method -eq 'Post' }
    }

    It 'Should send a single account as a root JSON array of numbers' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User 303950

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950]'
        }
    }

    It 'Should accept multiple accounts via pipeline' {
        303950, 303951, 303952 | Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950,303951,303952]'
        }
    }

    It 'Should batch operations at 100 accounts' {
        1..150 | Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 2 -Scope It
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq (ConvertTo-Json -InputObject (1..100) -Compress)
        }
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq (ConvertTo-Json -InputObject (101..150) -Compress)
        }
    }

    It 'Should respect ShouldProcess' {
        { Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User 303950 -WhatIf } | Should -Not -Throw
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 0 -Scope It
    }

    It 'Should accept numeric strings as account identifiers' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User '303950'

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950]'
        }
    }

    It 'Should accept multiple accounts as an array' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User @(303950, 303951)

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950,303951]'
        }
    }

    It 'Should support the UInt32 account identifier range' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User ([uint32]::MaxValue)

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[4294967295]'
        }
    }

    It 'Should reject invalid account identifiers before sending a request' -TestCases @(
        @{ User = 'invalid' }
        @{ User = 'u303950suffix' }
        @{ User = '-1' }
        @{ User = '4294967296' }
    ) {
        param($User)

        $Parameters = @{ APIToken = $TestAPIToken; User = $User }
        { Add-TeamViewerAddressBookHiddenMember @Parameters } | Should -Throw
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 0 -Scope It
    }

    It 'Should normalize prefixed user IDs without looking up users' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User 'u303950'

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950]'
        }
        Should -Invoke Get-TeamViewerUser -Times 0 -Scope It
    }

    It 'Should accept a TeamViewerPS.User through the pipeline without a lookup' {
        $Member = [pscustomobject]@{ Id = 'u303950'; Email = 'user@example.com' }
        $Member.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

        $Member | Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950]'
        }
        Should -Invoke Get-TeamViewerUser -Times 0 -Scope It
    }

    It 'Should resolve email input using the supplied token' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -Email 'user@example.com'

        Should -Invoke Get-TeamViewerUser -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $TestAPIToken -and $Email -eq 'user@example.com'
        }
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950]'
        }
    }

    It 'Should cache repeated email lookups across pipeline inputs' {
        'user@example.com', 'USER@example.com' | Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken

        Should -Invoke Get-TeamViewerUser -Times 1 -Scope It
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303950,303950]'
        }
    }

    It 'Should skip email lookup and mutation requests under WhatIf' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -Email 'user@example.com' -WhatIf

        Should -Invoke Get-TeamViewerUser -Times 0 -Scope It
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 0 -Scope It
    }

    It 'Should batch large array input into numeric arrays of at most 100 IDs' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User (1..201)

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 3 -Scope It
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq (ConvertTo-Json -InputObject (1..100) -Compress)
        }
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq (ConvertTo-Json -InputObject (101..200) -Compress)
        }
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[201]'
        }
    }

    It 'Should not send a request when email lookup fails' {
        Mock Get-TeamViewerUser { throw 'Lookup failed' }

        { Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -Email 'user@example.com' } | Should -Throw '*Lookup failed*'
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 0 -Scope It
    }

    It 'Should not send a request for missing or ambiguous email matches' -TestCases @(
        @{ MatchCount = 0 }
        @{ MatchCount = 2 }
    ) {
        param($MatchCount)

        $LookupResults = @(for ($Index = 0; $Index -lt $MatchCount; $Index++) {
                [pscustomobject]@{ Id = "u$($Index + 1)"; Email = 'user@example.com' }
            })
        Mock Get-TeamViewerUser { $LookupResults }

        { Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -Email 'user@example.com' } | Should -Throw '*user*found*'
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 0 -Scope It
    }

    It 'Should accept mixed input forms in one array' {
        $Member = [pscustomobject]@{ Id = 'u303953' }
        $Member.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -User @(303951, 'u303952', 'user@example.com', $Member)

        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 1 -Scope It -ParameterFilter {
            ($Body -replace '\s', '') -eq '[303951,303952,303950,303953]'
        }
        Should -Invoke Get-TeamViewerUser -Times 1 -Scope It
    }

    It 'Should not share email lookup caches between invocations' {
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -Email 'user@example.com'
        Add-TeamViewerAddressBookHiddenMember -APIToken $TestAPIToken -Email 'user@example.com'

        Should -Invoke Get-TeamViewerUser -Times 2 -Scope It
        Should -Invoke Invoke-TeamViewerJsonRestMethod -Times 2 -Scope It
    }
}
