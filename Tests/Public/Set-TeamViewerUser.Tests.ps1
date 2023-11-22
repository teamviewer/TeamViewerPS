BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body; @{ id = 'u1234' } }

    function ConvertTo-TestPassword {
        # We do this only for testing
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
        param()
        Process {
            $_ | ConvertTo-SecureString -AsPlainText -Force
        }
    }
}

Describe 'Set-TeamViewerUser' {

    It 'Should call the correct API endpoint' {
        Set-TeamViewerUser -ApiToken $testApiToken -User 'u1234' -Name 'Updated User Name'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/users/u1234' -And $Method -eq 'Put' }
    }

    It 'Should change user properties' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword
        $testSsoCustomerId = 'SsoTest' | ConvertTo-TestPassword

        Set-TeamViewerUser `
            -ApiToken $testApiToken `
            -User 'u1234' `
            -Name 'Updated User Name' `
            -Email 'foo@bar.com' `
            -Password $testPassword `
            -SsoCustomerIdentifier $testSsoCustomerId `
            -Permissions 'ManageAdmins', 'ManageUsers' `
            -Active $false

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Updated User Name'
        $body.email | Should -Be 'foo@bar.com'
        $body.password | Should -Be 'Test1234'
        $body.sso_customer_id | Should -Be 'SsoTest'
        $body.permissions | Should -Be 'ManageAdmins,ManageUsers'
        $body.active | Should -BeFalse
    }

    It 'Should accept user properties as hashtable' {
        Set-TeamViewerUser `
            -ApiToken $testApiToken `
            -User 'u1234' `
            -Property @{
            name            = 'Updated User Name'
            email           = 'foo@bar.com'
            password        = 'Test1234'
            sso_customer_id = 'SsoTest'
            permissions     = 'ManageAdmins,ManageUsers'
            active          = $false
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Updated User Name'
        $body.email | Should -Be 'foo@bar.com'
        $body.password | Should -Be 'Test1234'
        $body.sso_customer_id | Should -Be 'SsoTest'
        $body.permissions | Should -Be 'ManageAdmins,ManageUsers'
        $body.active | Should -BeFalse
    }

    It 'Should throw if hashtable does not contain any valid change' {
        { Set-TeamViewerUser -ApiToken $testApiToken -User 'u1234' -Property @{ foo = 'bar' } } | Should -Throw
    }
}
