BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerAddressBook.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerAddressBook' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerAddressBook -APIToken $testAPIToken -Enabled $true

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/companyaddressbook' -and $Method -eq 'Put' }
    }

    It 'Should update Enabled setting' {
        Set-TeamViewerAddressBook -APIToken $testAPIToken -Enabled $false

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.addressBookAvailable | Should -Be $false
    }

    It 'Should accept changes as hashtable' {
        Set-TeamViewerAddressBook -APIToken $testAPIToken -Property @{ addressBookAvailable = $true }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.addressBookAvailable | Should -Be $true
    }

    It 'Should throw if input does not contain any valid change' {
        { Set-TeamViewerAddressBook -APIToken $testAPIToken } | Should -Throw
    }
}
