BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerAddressBookUser.ps1"
}

Describe 'ConvertTo-TeamViewerAddressBookUser' {
    It 'Converts address book user fields' {
        $InputObject = @{
            accountId = 'abc123'
            email     = 'user@example.com'
            name      = 'User'
        }

        $Result = ConvertTo-TeamViewerAddressBookUser -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBookUser'
        $Result.UserId | Should -Be 'abc123'
        $Result.Email | Should -Be 'user@example.com'
        $Result.Name | Should -Be 'User'
        $Result.PSObject.Properties.Name | Should -Not -Contain 'AccountId'
    }
}
