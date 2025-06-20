BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

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

Describe 'New-TeamViewerUser' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerUser -ApiToken $testApiToken -Name 'Unit Test User' -Email 'user1@unit.test' -WithoutPassword

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/users' -And $Method -eq 'Post' }
    }

    It 'Should include the given name and email in the request' {
        New-TeamViewerUser -ApiToken $testApiToken -Name 'Unit Test User' -Email 'user1@unit.test' -WithoutPassword

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Unit Test User'
        $body.email | Should -Be 'user1@unit.test'
    }

    It 'Should return the new user object' {
        $result = New-TeamViewerUser -ApiToken $testApiToken -Name 'Unit Test User' -Email 'user1@unit.test' -WithoutPassword

        $result | Should -Not -BeNullOrEmpty
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.User'
        $result.id | Should -Be 'u1234'
        $result.email | Should -Be 'user1@unit.test'
    }

    It 'Should use the TeamViewer language name for the given culture-info <inputCulture>' -TestCases @(
        @{ inputCulture = [cultureinfo]'de-DE'; expected = 'de' }
        @{ inputCulture = [cultureinfo]'en-US'; expected = 'en' }
        @{ inputCulture = [cultureinfo]'zh-CN'; expected = 'zh_CN' }
        @{ inputCulture = [cultureinfo]'zh-TW'; expected = 'zh_TW' }
    ) {
        param($inputCulture, $expected)
        New-TeamViewerUser -ApiToken $testApiToken -Name 'Unit Test User' -Email 'user1@unit.test' -Culture $inputCulture -WithoutPassword

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.language | Should -Be $expected
    }

    It 'Should allow to specify a password for the new user' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword

        New-TeamViewerUser -ApiToken $testApiToken -Name 'Unit Test User' -Email 'user1@unit.test' -Password $testPassword

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.password | Should -Be 'Test1234'
    }

    It 'Should allow to create a SSO-enabled user' {
        $testSsoCustomerId = 'my-sso-customer-id' | ConvertTo-TestPassword

        New-TeamViewerUser -ApiToken $testApiToken -Name 'Unit Test User' -Email 'user1@unit.test' -WithoutPassword -SsoCustomerIdentifier $testSsoCustomerId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.sso_customer_id | Should -Be 'my-sso-customer-id'
    }

    It 'Should allow to create a user with all attributes using -WithoutPassword' {
        $testSsoCustomerId = 'my-sso-customer-id' | ConvertTo-TestPassword
        $testCulture = [cultureinfo]'en-US'
        $testRoleId = '00000000-0000-0000-0000-000000000000'


        # Aufruf der Funktion mit allen Parametern
        New-TeamViewerUser `
            -ApiToken $testApiToken `
            -Email 'user1@unit.test' `
            -Name 'Unit Test User' `
            -WithoutPassword `
            -SsoCustomerIdentifier $testSsoCustomerId `
            -Culture $testCulture `
            -RoleId $testRoleId `
            -Active $true `
            -LogSessions $true `
            -ShowCommentWindow $true `
            -SubscribeNewsletter $true `
            -CustomQuickSupportId 'quick-support-id' `
            -CustomQuickJoinId 'quick-join-id' `
            -LicenseKey 'license-key' `
            -MeetingLicenseKey 'meeting-license-key' `
            -IgnorePredefinedRole

        $mockArgs.Body | Should -Not -BeNullOrEmpty

        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json

        $body.email | Should -Be 'user1@unit.test'
        $body.name | Should -Be 'Unit Test User'
        $body.sso_customer_id | Should -Be 'my-sso-customer-id'
        $body.language | Should -Be 'en'
        $body.userRoleId | Should -Contain '00000000-0000-0000-0000-000000000000'
        $body.active | Should -Be $true
        $body.log_sessions | Should -Be $true
        $body.show_comment_window | Should -Be $true
        $body.subscribe_newsletter | Should -Be $true
        $body.custom_quicksupport_id | Should -Be 'quick-support-id'
        $body.custom_quickjoin_id | Should -Be 'quick-join-id'
        $body.license_key | Should -Be 'license-key'
        $body.meeting_license_key | Should -Be 'meeting-license-key'
        $body.ignorePredefinedRole | Should -Be $true
    }


}
