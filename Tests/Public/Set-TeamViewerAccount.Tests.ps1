BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerAccount.ps1"

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
        Process { $_ | ConvertTo-SecureString -AsPlainText -Force }
    }
}

Describe 'Set-TeamViewerAccount' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerAccount `
            -ApiToken $testApiToken `
            -Name 'Updated Account Name' `
            -Email 'unit@example.test' `

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/account' -And `
                $Method -eq 'Put' }
    }

    It 'Should change account properties' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword
        $testOldPassword = 'Test5678' | ConvertTo-TestPassword

        Set-TeamViewerAccount `
            -ApiToken $testApiToken `
            -Name 'Updated Account Name' `
            -Email 'unit@example.test' `
            -Password $testPassword `
            -OldPassword $testOldPassword `
            -EmailLanguage 'de'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Updated Account Name'
        $body.email | Should -Be 'unit@example.test'
        $body.password | Should -Be 'Test1234'
        $body.oldpassword | Should -Be 'Test5678'
        $body.email_language | Should -Be 'de'
    }

    It 'Should accept changes as hashtable' {
        Set-TeamViewerAccount `
            -ApiToken $testApiToken `
            -Property @{
            name           = 'Updated Account Name'
            email          = 'unit@example.test'
            password       = 'Test1234'
            oldpassword    = 'Test5678'
            email_language = 'de'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Updated Account Name'
        $body.email | Should -Be 'unit@example.test'
        $body.password | Should -Be 'Test1234'
        $body.oldpassword | Should -Be 'Test5678'
        $body.email_language | Should -Be 'de'
    }

    It 'Should throw if input does not contain any valid change' {
        { Set-TeamViewerAccount -ApiToken $testApiToken } | Should -Throw
    }
}
