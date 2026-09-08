BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerAddressBookHiddenMember.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            accountIds          = @(
                'account1',
                'account2',
                'account3'
            )
            continuation_token  = $null
        }
    }
}

Describe 'Get-TeamViewerAddressBookHiddenMember' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/companyaddressbook/hiddenmembers' -and $Method -eq 'Get' }
    }

    It 'Should return hidden member account IDs' {
        $Result = Get-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken
        $Result | Should -HaveCount 3
        $Result | Should -Contain 'account1'
        $Result | Should -Contain 'account2'
        $Result | Should -Contain 'account3'
    }

    It 'Should fetch consecutive pages' {
        Mock Invoke-TeamViewerRestMethod { @{
                accountIds          = @(
                    'account4',
                    'account5'
                )
                continuation_token  = 'token456'
            } }

        Mock Invoke-TeamViewerRestMethod { @{
                accountIds          = @(
                    'account6'
                )
                continuation_token  = $null
            } } -ParameterFilter { $Body -and $Body['ct'] -eq 'token456' }

        $Result = Get-TeamViewerAddressBookHiddenMember -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
    }
}
