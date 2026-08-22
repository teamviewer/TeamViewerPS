BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerLicenseInformation.ps1')
}

Describe 'ConvertTo-TeamViewerLicenseInformation' {
    It 'Returns an object for pipeline input' {
        $InputObject = [pscustomobject]@{
            licenseName = 'Tensor'
            version = '15'
            type = 'Business'
            licenseId = ([guid]::NewGuid().ToString())
            isActive = $true
            aiCredits = '2'
            managedDevices = '3'
            assignedUsers = '4'
            displayName = 'Tensor Display'
            details = 'License details'
            numberOfChannels = '1'
            maxAssignments = '5'
            totalTechnicians = '6'
        }

        $Result = $InputObject | & ConvertTo-TeamViewerLicenseInformation

        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.LicenseInformation'
        $Result.Name | Should -Be 'Tensor'
    }

    It 'Supports pipeline processing of multiple items' {
        $InputObjects = @(
            [pscustomobject]@{ licenseName = 'One'; version='1'; type='Business'; licenseId=([guid]::NewGuid().ToString()); isActive=$true; aiCredits='1'; managedDevices='1'; assignedUsers='1'; displayName='One'; details='D'; numberOfChannels='1'; maxAssignments='1'; totalTechnicians='1' },
            [pscustomobject]@{ licenseName = 'Two'; version='2'; type='Business'; licenseId=([guid]::NewGuid().ToString()); isActive=$false; aiCredits='2'; managedDevices='2'; assignedUsers='2'; displayName='Two'; details='D'; numberOfChannels='2'; maxAssignments='2'; totalTechnicians='2' }
        )

        $Result = $InputObjects | & ConvertTo-TeamViewerLicenseInformation

        @($Result).Count | Should -Be 2
    }
}
