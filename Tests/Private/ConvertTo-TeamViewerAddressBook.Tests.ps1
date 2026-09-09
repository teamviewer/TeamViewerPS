BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Script:Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Script:Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerAddressBookUser.ps1')
    . (Join-Path -Path $Script:Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerAddressBook.ps1')
}

Describe 'ConvertTo-TeamViewerAddressBook' {
    It 'Adds address book types without changing response properties' {
        $InputObject = [pscustomobject]@{
            companyAddressBookSettings = @{ addressBookAvailable = $true }
            users                      = @([pscustomobject]@{ accountId = 'abc123'; email = 'user@example.com' })
            continuation_token         = $null
        }

        $Result = ConvertTo-TeamViewerAddressBook -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBook'
        $Result.Enabled | Should -BeTrue
        $Result.companyAddressBookSettings.addressBookAvailable | Should -BeTrue
        $Result.users[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBookUser'
        $Result.users[0].UserId | Should -Be 'abc123'
        $Result.users[0].AccountId | Should -Be 'abc123'
        $Result.users[0].Email | Should -Be 'user@example.com'
    }

    It 'Handles a missing users property without throwing' {
        $InputObject = [pscustomobject]@{
            companyAddressBookSettings = @{ addressBookAvailable = $false }
            continuation_token         = $null
        }

        $Result = ConvertTo-TeamViewerAddressBook -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBook'
        $Result.Enabled | Should -BeFalse
        $Result.users | Should -BeNullOrEmpty
    }

    It 'Maps the top-level state field to Enabled' {
        $InputObject = [pscustomobject]@{
            state = $true
        }

        $Result = ConvertTo-TeamViewerAddressBook -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBook'
        $Result.Enabled | Should -BeTrue
        $Result.users | Should -BeNullOrEmpty
    }
}
