BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerLicenseInformation.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerLicense.ps1')
}

Describe 'ConvertTo-TeamViewerLicense' {
    It 'Maps license and nested license information' {
        $licenseInfoId = [guid]::NewGuid().ToString()
        $InputObject = [pscustomobject]@{
            companyId = '42'
            companyName = 'Acme'
            available_licenses = @([pscustomobject]@{ licenseName='Tensor'; version='15'; type='Business'; licenseId=$licenseInfoId; isActive=$true; aiCredits='2'; managedDevices='3'; assignedUsers='4'; displayName='Tensor'; details='D'; numberOfChannels='1'; maxAssignments='5'; totalTechnicians='6' })
        }

        $Result = ConvertTo-TeamViewerLicense -InputObject $InputObject

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.License'
        $Result.Id | Should -Be 42
        $Result.Licenses_Available.Count | Should -Be 1
        $Result.Licenses_Available[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.LicenseInformation'
    }
}
