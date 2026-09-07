BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerEffectivePermission.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        Get-TeamViewerEffectivePermission -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and `
                $Uri -eq '//unit.test/users/effectivepermissions' -and `
                $Method -eq 'Get' }
    }

    It 'Should convert input object to TeamViewerPS.EffectivePermission' {
        $Result = Get-TeamViewerEffectivePermission -APIToken $testAPIToken

        $Result | Should -BeOfType [PSCustomObject]
        $Result.AllowGroupSharing | Should -Be $true
        $Result.ManageAdmins | Should -Be $false
        $Result.ManageUsers | Should -Be $true
        $Result.ModifyConnections | Should -Be $true
    }

    It 'Should return an empty object if no permissions are assigned' {
        Mock Invoke-TeamViewerRestMethod {
            @{
            }
        }

        $Result = Get-TeamViewerEffectivePermission -APIToken $testAPIToken
        $Result | Should -BeOfType [PSCustomObject]
        $Result.PSObject.Properties | Should -Be $null

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/users/effectivepermissions' -and $Method -eq 'Get' }
    }
}
