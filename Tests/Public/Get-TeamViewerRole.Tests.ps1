
BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

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

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/userroles' -and `
                $Method -eq 'Get' }
    }

    It 'Should convert input object to TeamViewerPS.Role' {
        $InputObject = @{
            id          = 'a9c9435d-8544-4e6a-9830-9337078c9aab'
            name        = 'Role 1'
            Permissions = @{
                AllowGroupSharing = $true
                ManageAdmins      = $false
                ManageUsers       = $true
                ModifyConnections = $true
            }
        } | ConvertTo-Json

        $Result = $InputObject | ConvertFrom-Json | ConvertTo-TeamViewerRole

        $Result | Should -BeOfType [PSCustomObject]
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Role'
        $Result.Name | Should -Be 'Role 1'
        $Result.Id | Should -Be 'a9c9435d-8544-4e6a-9830-9337078c9aab'
        $Result.Permissions.AllowGroupSharing | Should -Be $true
        $Result.Permissions.ManageAdmins | Should -Be $false
        $Result.Permissions.ManageUsers | Should -Be $true
        $Result.Permissions.ModifyConnections | Should -Be $true
        $Result.PSObject.Properties.Name | Should -Not -Contain 'AllowGroupSharing'
    }

    It 'Should call the correct API endpoint for assigned users' {
        Get-TeamViewerRole -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/userroles' -and $Method -eq 'Get' }
    }
    It 'Should return Role objects' {
        $Result = Get-TeamViewerRole -ApiToken $testApiToken
        $Result | Should -HaveCount 2
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Role'
    }
}
