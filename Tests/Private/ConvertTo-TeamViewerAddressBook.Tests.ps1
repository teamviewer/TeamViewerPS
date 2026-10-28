BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Script:Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Script:Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerAddressBook.ps1')
}

Describe 'ConvertTo-TeamViewerAddressBook' {
    It 'Adds address book type and Enabled without retaining users' {
        $InputObject = [pscustomobject]@{
            companyAddressBookSettings = @{ addressBookAvailable = $true }
            users                      = @([pscustomobject]@{ accountId = 'abc123'; email = 'user@example.com' })
            continuation_token         = $null
        }

        $Result = ConvertTo-TeamViewerAddressBook -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBook'
        $Result.Enabled | Should -BeTrue
        $Result.companyAddressBookSettings.addressBookAvailable | Should -BeTrue
        $Result.PSObject.Properties.Name | Should -Not -Contain 'users'
    }

    It 'Handles a missing users property without throwing' {
        $InputObject = [pscustomobject]@{
            companyAddressBookSettings = @{ addressBookAvailable = $false }
            continuation_token         = $null
        }

        $Result = ConvertTo-TeamViewerAddressBook -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBook'
        $Result.Enabled | Should -BeFalse
        $Result.PSObject.Properties.Name | Should -Not -Contain 'users'
    }

    It 'Maps the top-level state field to Enabled' {
        $InputObject = [pscustomobject]@{
            state = $true
        }

        $Result = ConvertTo-TeamViewerAddressBook -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBook'
        $Result.Enabled | Should -BeTrue
        $Result.PSObject.Properties.Name | Should -Not -Contain 'users'
    }
}
