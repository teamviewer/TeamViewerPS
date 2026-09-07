BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerAccount.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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

Describe 'Set-TeamViewerAccount' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerAccount -APIToken $testAPIToken -Name 'Updated Account Name' -Email 'unit@example.test'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/account' -and $Method -eq 'Put' }
    }

    It 'Should change account properties' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword
        $testOldPassword = 'Test5678' | ConvertTo-TestPassword

        Set-TeamViewerAccount -APIToken $testAPIToken -Name 'Updated Account Name' -Email 'unit@example.test' -Password $testPassword -OldPassword $testOldPassword -EmailLanguage 'de'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated Account Name'
        $Body.email | Should -Be 'unit@example.test'
        $Body.password | Should -Be 'Test1234'
        $Body.oldpassword | Should -Be 'Test5678'
        $Body.email_language | Should -Be 'de'
    }

    It 'Should accept changes as hashtable' {
        Set-TeamViewerAccount -APIToken $testAPIToken -Property @{
            name           = 'Updated Account Name'
            email          = 'unit@example.test'
            password       = 'Test1234'
            oldpassword    = 'Test5678'
            email_language = 'de'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated Account Name'
        $Body.email | Should -Be 'unit@example.test'
        $Body.password | Should -Be 'Test1234'
        $Body.oldpassword | Should -Be 'Test5678'
        $Body.email_language | Should -Be 'de'
    }

    It 'Should throw if input does not contain any valid change' {
        { Set-TeamViewerAccount -APIToken $testAPIToken } | Should -Throw
    }
}
