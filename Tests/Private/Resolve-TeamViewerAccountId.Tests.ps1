BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\Resolve-TeamViewerAccountId.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUser.ps1"

    $TestAPIToken = [securestring]@{}
    $null = $TestAPIToken
    Mock Get-TeamViewerUser { [pscustomobject]@{ Id = 'u303950'; Email = 'user@example.com' } }
}

Describe 'Resolve-TeamViewerAccountId' {
    It 'Should return UInt32 for supported identifiers' -TestCases @(
        @{ User = 303950; Expected = 303950 }
        @{ User = '303950'; Expected = 303950 }
        @{ User = 'u303950'; Expected = 303950 }
        @{ User = '0'; Expected = 0 }
        @{ User = '4294967295'; Expected = [uint32]::MaxValue }
    ) {
        param($User, $Expected)

        $Result = Resolve-TeamViewerAccountId -APIToken $TestAPIToken -User $User

        $Result | Should -Be $Expected
        $Result | Should -BeOfType ([uint32])
        Should -Invoke Get-TeamViewerUser -Times 0 -Scope It
    }

    It 'Should extract the ID from a typed user object' {
        $Member = [pscustomobject]@{ Id = 'u303950' }
        $Member.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

        Resolve-TeamViewerAccountId -APIToken $TestAPIToken -User $Member | Should -Be 303950
        Should -Invoke Get-TeamViewerUser -Times 0 -Scope It
    }

    It 'Should reject malformed and out-of-range identifiers' -TestCases @(
        @{ User = '-1' }
        @{ User = '4294967296' }
        @{ User = 'u4294967296' }
        @{ User = 'prefixu303950' }
        @{ User = 'u303950suffix' }
        @{ User = '1.5' }
        @{ User = [pscustomobject]@{ Id = 'u303950' } }
    ) {
        param($User)

        $Parameters = @{ APIToken = $TestAPIToken; User = $User }
        { Resolve-TeamViewerAccountId @Parameters } | Should -Throw '*Invalid account identifier*'
        Should -Invoke Get-TeamViewerUser -Times 0 -Scope It
    }

    It 'Should select only an exact case-insensitive email match' {
        Mock Get-TeamViewerUser {
            [pscustomobject]@{ Id = 'u1'; Email = 'otheruser@example.com' }
            [pscustomobject]@{ Id = 'u303950'; Email = 'USER@example.com' }
        }

        Resolve-TeamViewerAccountId -APIToken $TestAPIToken -User 'user@example.com' | Should -Be 303950
        Should -Invoke Get-TeamViewerUser -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $TestAPIToken -and $Email -eq 'user@example.com'
        }
    }

    It 'Should report no exact email match' {
        Mock Get-TeamViewerUser { [pscustomobject]@{ Id = 'u1'; Email = 'otheruser@example.com' } }

        { Resolve-TeamViewerAccountId -APIToken $TestAPIToken -User 'user@example.com' } |
        Should -Throw '*No TeamViewer user found*'
    }

    It 'Should report ambiguous email matches' {
        Mock Get-TeamViewerUser {
            [pscustomobject]@{ Id = 'u1'; Email = 'user@example.com' }
            [pscustomobject]@{ Id = 'u2'; Email = 'USER@example.com' }
        }

        { Resolve-TeamViewerAccountId -APIToken $TestAPIToken -User 'user@example.com' } |
        Should -Throw '*Multiple TeamViewer users found*'
    }

    It 'Should reject invalid IDs returned by an email lookup' {
        Mock Get-TeamViewerUser { [pscustomobject]@{ Id = 'invalid'; Email = 'user@example.com' } }

        { Resolve-TeamViewerAccountId -APIToken $TestAPIToken -User 'user@example.com' } |
        Should -Throw '*Invalid account identifier*'
    }

    It 'Should preserve the cached email ID when a different numeric ID follows' {
        $EmailCache = @{}
        $Results = 'user@example.com', '303951', 'USER@example.com' |
        Resolve-TeamViewerAccountId -APIToken $TestAPIToken -EmailCache $EmailCache

        ($Results -join ',') | Should -Be '303950,303951,303950'
        $EmailCache['user@example.com'] | Should -Be 303950
        Should -Invoke Get-TeamViewerUser -Times 1 -Scope It
    }
}
