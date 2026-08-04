BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerLicense.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

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
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/company/license' -and `
                $Method -eq 'Get' }
    }

    It 'Should return License object' {
        $result = Get-TeamViewerLicense -ApiToken $testApiToken
        $result | Should -Not -BeNullOrEmpty
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.License'
        $result.CompanyId | Should -Be 42
        $result.CompanyName | Should -Be 'TeamViewer Germany GmbH'
        $result.AvailableLicenses | Should -HaveCount 1
        $result.AvailableLicenses[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.LicenseInformation'
        $result.AvailableLicenses[0].LicenseName | Should -Be 'Tensor'
        $result.ToString() | Should -Be 'TeamViewer Germany GmbH'
    }
}
