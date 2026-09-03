BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerPredefinedRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{ PredefineduserRoleId = 'e1631449-6321-4a58-920c-5440029b092e' }
    }
}

Describe 'Get-TeamViewerPredefinedRole' {
    It 'Should call the correct API endpoint to list PredefinedRole' {
        Get-TeamViewerPredefinedRole -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/userroles/predefined' -and $Method -eq 'Get' }
    }

    It 'Should convert input object to TeamViewerPS.PrefinedRole' {
        $InputObject = @{
            PredefineduserRoleId = 'a9c9435d-8544-4e6a-9830-9337078c9aab'
        } | ConvertTo-Json

        $Result = $InputObject | ConvertFrom-Json | ConvertTo-TeamViewerPredefinedRole

        $Result | Should -BeOfType [PSCustomObject]
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.PredefinedRole'
        $Result.Role_Id | Should -Be 'a9c9435d-8544-4e6a-9830-9337078c9aab'
    }

    It 'Should return PredefinedRole objects' {
        $Result = Get-TeamViewerPredefinedRole -ApiToken $testApiToken
        $Result | Should -HaveCount 1
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.PredefinedRole'
    }
}
