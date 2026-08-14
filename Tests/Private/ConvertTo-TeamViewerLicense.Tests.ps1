BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerLicenseInformation.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerLicense.ps1')
}

Describe 'ConvertTo-TeamViewerLicense' {
    It 'Maps license and nested license information' {
        $licenseInfoId = [guid]::NewGuid().ToString()
        $inputObject = [pscustomobject]@{
            companyId = '42'
            companyName = 'Acme'
            available_licenses = @([pscustomobject]@{ licenseName='Tensor'; version='15'; type='Business'; licenseId=$licenseInfoId; isActive=$true; aiCredits='2'; managedDevices='3'; assignedUsers='4'; displayName='Tensor'; details='D'; numberOfChannels='1'; maxAssignments='5'; totalTechnicians='6' })
        }

        $result = ConvertTo-TeamViewerLicense -InputObject $inputObject

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.License'
        $result.CompanyId | Should -Be 42
        $result.AvailableLicenses.Count | Should -Be 1
        $result.AvailableLicenses[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.LicenseInformation'
    }
}
