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
        process {
            $_ | ConvertTo-SecureString -AsPlainText -Force
        }
    }
}

Describe 'Set-TeamViewerUser' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerUser -ApiToken $testApiToken -User 'u1234' -Name 'Updated User Name'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/users/u1234' -and $Method -eq 'Put' }
    }

    It 'Should change user properties' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword
        $testSsoCustomerId = 'SsoTest' | ConvertTo-TestPassword

        Set-TeamViewerUser -ApiToken $testApiToken -User 'u1234' -Name 'Updated User Name' -Email 'foo@bar.com' -Password $testPassword -SsoCustomerIdentifier $testSsoCustomerId -Active $false

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated User Name'
        $Body.email | Should -Be 'foo@bar.com'
        $Body.password | Should -Be 'Test1234'
        $Body.sso_customer_id | Should -Be 'SsoTest'
        $Body.active | Should -BeFalse
    }

    It 'Should change all user properties via direct parameters' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword
        $testSsoCustomerId = 'SsoTest' | ConvertTo-TestPassword
        $testApiToken = 'dummy-token' | ConvertTo-TestPassword

        Set-TeamViewerUser `
            -ApiToken $testApiToken `
            -User 'u1234' `
            -Name 'Updated User Name' `
            -Email 'foo@bar.com' `
            -Password $testPassword `
            -SsoCustomerIdentifier $testSsoCustomerId `
            -Active $false `
            -LogSessions $true `
            -ShowCommentWindow $true `
            -TFAEnforcement $true `
            -CustomQuickSupportId 'quick-id' `
            -CustomQuickJoinId 'join-id' `
            -LicenseKey 'license-xyz'`
            -AssignRoleId @('11111111-1111-1111-1111-111111111111')`
            -UnassignRoleId @('22222222-2222-2222-2222-222222222222')

        $mockArgs.Body | Should -Not -BeNullOrEmpty

        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json

        $Body.name | Should -Be 'Updated User Name'
        $Body.email | Should -Be 'foo@bar.com'
        $Body.password | Should -Be 'Test1234'
        $Body.sso_customer_id | Should -Be 'SsoTest'
        $Body.active | Should -BeFalse
        $Body.log_sessions | Should -BeTrue
        $Body.show_comment_window | Should -BeTrue
        $Body.tfa_enforcement | Should -BeTrue
        $Body.custom_quicksupport_id | Should -Be 'quick-id'
        $Body.custom_quickjoin_id | Should -Be 'join-id'
        $Body.license_key | Should -Be 'license-xyz'
        $Body.AssignUserRoleIds | Should -Contain '11111111-1111-1111-1111-111111111111'
        $Body.UnassignUserRoleIds | Should -Contain '22222222-2222-2222-2222-222222222222'
    }

    It 'Should accept all user properties via hashtable' {
        Set-TeamViewerUser `
            -ApiToken $testApiToken `
            -User 'u1234' `
            -Property @{
            name                   = 'Updated User Name'
            email                  = 'foo@bar.com'
            password               = 'Test1234'
            sso_customer_id        = 'SsoTest'
            permissions            = 'ManageAdmins,ManageUsers'
            active                 = $false
            log_sessions           = $true
            show_comment_window    = $true
            tfa_enforcement        = $true
            custom_quicksupport_id = 'quick-id'
            custom_quickjoin_id    = 'join-id'
            license_key            = 'license-xyz'
            UnassignUserRoleIds    = @('11111111-1111-1111-1111-111111111111')
            AssignUserRoleIds      = @('22222222-2222-2222-2222-222222222222')
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty

        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json

        $Body.name | Should -Be 'Updated User Name'
        $Body.email | Should -Be 'foo@bar.com'
        $Body.password | Should -Be 'Test1234'
        $Body.sso_customer_id | Should -Be 'SsoTest'
        $Body.permissions | Should -Be 'ManageAdmins,ManageUsers'
        $Body.active | Should -BeFalse
        $Body.log_sessions | Should -BeTrue
        $Body.show_comment_window | Should -BeTrue
        $Body.tfa_enforcement | Should -BeTrue
        $Body.custom_quicksupport_id | Should -Be 'quick-id'
        $Body.custom_quickjoin_id | Should -Be 'join-id'
        $Body.license_key | Should -Be 'license-xyz'

        $Body.UnassignUserRoleIds | Should -Contain '11111111-1111-1111-1111-111111111111'
        $Body.AssignUserRoleIds | Should -Contain '22222222-2222-2222-2222-222222222222'
    }

    It 'Should throw if hashtable does not contain any valid change' {
        { Set-TeamViewerUser -ApiToken $testApiToken -User 'u1234' -Property @{ foo = 'bar' } } | Should -Throw
    }
}
