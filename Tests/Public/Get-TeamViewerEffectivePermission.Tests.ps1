BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerEffectivePermission.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            AllowGroupSharing = $true
            ManageAdmins      = $false
            ManageUsers       = $true
            ModifyConnections = $true
            DeleteConnections = $true
        }
    }
}

Describe 'Get-TeamViewerEffectivePermission' {

    It 'Should call the correct API endpoint to list permission' {
        Get-TeamViewerEffectivePermission -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/users/effectivepermissions' -and `
                $Method -eq 'Get' }
    }

    It 'Should convert input object to TeamViewerPS.EffectivePermission' {

        $result = Get-TeamViewerEffectivePermission -ApiToken $testApiToken

        $result | Should -BeOfType [PSCustomObject]
        $result.AllowGroupSharing | Should -Be $true
        $result.ManageAdmins | Should -Be $false
        $result.ManageUsers | Should -Be $true
        $result.ModifyConnections | Should -Be $true
    }

    It 'Should return an empty object if no permissions are assigned' {
        Mock Invoke-TeamViewerRestMethod {
            @{
            }
        }

        $result = Get-TeamViewerEffectivePermission -ApiToken $testApiToken
        $result | Should -BeOfType [PSCustomObject]
        $result.PSObject.Properties | Should -Be $null
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/users/effectivepermissions' -and `
                $Method -eq 'Get' }
    }

}
