BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerPredefinedRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{ PredefinedRoleId = 'e1631449-6321-4a58-920c-5440029b092e' }
    }
}


Describe 'Get-TeamViewerPredefinedRole' {

    It 'Should call the correct API endpoint to list PredefinedRole' {
        Get-TeamViewerPredefinedRole -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles/predefined' -And `
                $Method -eq 'Get' }
    }

    It 'Should convert input object to TeamViewerPS.PrefinedRole' {
        $inputObject = @{
            PredefinedRoleId = 'a9c9435d-8544-4e6a-9830-9337078c9aab'
        } | ConvertTo-Json

        $result = $inputObject | ConvertFrom-Json | ConvertTo-TeamViewerPredefinedRole

        $result | Should -BeOfType [PSCustomObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.PredefinedRole'
        $result.PredefinedRoleID | Should -Be 'a9c9435d-8544-4e6a-9830-9337078c9aab'
    }


    It 'Should return PredefinedRole objects' {
        $result = Get-TeamViewerPredefinedRole -ApiToken $testApiToken
        $result | Should -HaveCount 1
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.PredefinedRole'
    }
}
