BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerAddressBook.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            companyAddressBookSettings = @{
                userCanCreatePersonalGroups = $true
                addressBookAvailable        = $true
            }
            users                      = @(
                @{
                    accountId = 'abc123'
                    email     = 'test1@example.com'
                },
                @{
                    accountId = 'def456'
                    email     = 'test2@example.com'
                }
            )
            continuation_token         = $null
        }
    }
}

Describe 'Get-TeamViewerAddressBook' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerAddressBook -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/companyaddressbook' -and $Method -eq 'Get' }
    }

    It 'Should return address book data' {
        $Result = Get-TeamViewerAddressBook -APIToken $testAPIToken
        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBook'
        $Result.Enabled | Should -BeTrue
        $Result.companyAddressBookSettings | Should -Not -BeNullOrEmpty
        $Result.users | Should -HaveCount 2
        $Result.users[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AddressBookUser'
        $Result.users[0].UserId | Should -Be 'abc123'
        $Result.users[0].PSObject.Properties.Name | Should -Not -Contain 'AccountId'
    }

    It 'Should fetch consecutive pages' {
        Mock Invoke-TeamViewerRestMethod { @{
                companyAddressBookSettings = @{
                    userCanCreatePersonalGroups = $true
                    addressBookAvailable        = $true
                }
                users                      = @(
                    @{
                        accountId = 'ghi789'
                        email     = 'test3@example.com'
                    }
                )
                continuation_token         = 'token123'
            } }

        Mock Invoke-TeamViewerRestMethod { @{
                companyAddressBookSettings = @{
                    userCanCreatePersonalGroups = $true
                    addressBookAvailable        = $true
                }
                users                      = @(
                    @{
                        accountId = 'jkl012'
                        email     = 'test4@example.com'
                    }
                )
                continuation_token         = $null
            } } -ParameterFilter { $Body -and $Body['ct'] -eq 'token123' }

        Get-TeamViewerAddressBook -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
    }
}
