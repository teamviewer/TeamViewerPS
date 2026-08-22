BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRolePermission.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            Permissions = @('ManageAdmins', 'AllowGroupSharing')
        }
    }
}

Describe 'Get-TeamViewerRolePermission' {
    It 'Should call the correct API endpoint to list permissions' {
        Get-TeamViewerRolePermission -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/userroles/permissions' -and `
                $Method -eq 'Get' }
    }

    It 'Should return the permissions' {
        $Result = @(Get-TeamViewerRolePermission -ApiToken $testApiToken)

        $Result | Should -Be @('AllowGroupSharing', 'ManageAdmins')
    }

    It 'Should return permissions when the response is an array' {
        Mock Invoke-TeamViewerRestMethod { @('ManageAdmins', 'AllowGroupSharing') }

        $Result = @(Get-TeamViewerRolePermission -ApiToken $testApiToken)

        $Result | Should -Be @('AllowGroupSharing', 'ManageAdmins')
    }
}
