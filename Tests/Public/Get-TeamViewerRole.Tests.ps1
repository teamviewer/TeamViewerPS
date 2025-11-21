
BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            Roles = @(
                @{ id = 'a9c9435d-8544-4e6a-9830-9337078c9aab'; name = 'Role 1'; },
                @{ id = 'e1631449-6321-4a58-920c-5440029b092e'; name = 'Role 2'; }
            )
        }
    }
}

Describe 'Get-TeamViewerRole' {

    It 'Should call the correct API endpoint to list roles' {
        Get-TeamViewerRole -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles' -And `
                $Method -eq 'Get' }
    }

    It 'Should convert input object to TeamViewerPS.Role' {
        $inputObject = @{
            id          = 'a9c9435d-8544-4e6a-9830-9337078c9aab'
            name        = 'Role 1'
            Permissions = @{
                AllowGroupSharing = $true
                ManageAdmins      = $false
                ManageUsers       = $true
                ModifyConnections = $true
            }
        } | ConvertTo-Json

        $result = $inputObject | ConvertFrom-Json | ConvertTo-TeamViewerRole

        $result | Should -BeOfType [PSCustomObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Role'
        $result.RoleName | Should -Be 'Role 1'
        $result.RoleID | Should -Be 'a9c9435d-8544-4e6a-9830-9337078c9aab'
        $result.AllowGroupSharing | Should -Be $true
        $result.ManageAdmins | Should -Be $false
        $result.ManageUsers | Should -Be $true
        $result.ModifyConnections | Should -Be $true
    }

    It 'Should call the correct API endpoint for assigned users' {
        Get-TeamViewerRole -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles' -And `
                $Method -eq 'Get' }
    }
    It 'Should call the correct API endpoint to list permissions' {
        Get-TeamViewerRole -ApiToken $testApiToken -Permissions

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles/permissions' -And `
                $Method -eq 'Get' }
    }

    It 'Should return Role objects' {
        $result = Get-TeamViewerRole -ApiToken $testApiToken
        $result | Should -HaveCount 2
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Role'
    }
}
