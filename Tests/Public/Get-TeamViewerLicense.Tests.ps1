BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerLicense.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            companyId          = 42
            companyName        = 'TeamViewer Germany GmbH'
            available_licenses = @(
                @{
                    licenseName      = 'Tensor'
                    version          = 1
                    type             = 'subscription'
                    licenseId        = '00000000-0000-0000-0000-000000000001'
                    isActive         = $true
                    aiCredits        = 10
                    managedDevices   = 5
                    assignedUsers    = 2
                    displayName      = 'Tensor'
                    details          = 'Main license'
                    numberOfChannels = 3
                    maxAssignments   = 5
                    totalTechnicians = 2
                }
            )
        }
    }
}

Describe 'Get-TeamViewerLicense' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerLicense -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/company/license' -and $Method -eq 'Get' }
    }

    It 'Should return License object' {
        $Result = Get-TeamViewerLicense -ApiToken $testApiToken
        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.License'
        $Result.Id | Should -Be 42
        $Result.Name | Should -Be 'TeamViewer Germany GmbH'
        $Result.Licenses_Available | Should -HaveCount 1
        $Result.Licenses_Available[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.LicenseInformation'
        $Result.Licenses_Available[0].Name | Should -Be 'Tensor'
    }
}
