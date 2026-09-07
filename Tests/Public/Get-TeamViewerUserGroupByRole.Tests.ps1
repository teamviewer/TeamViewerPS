BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserGroupByRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $Assigned = @('1001', '1002')
    Mock Invoke-TeamViewerRestMethod { @{
            ContinuationToken = $null
            AssignedToGroups  = $Assigned
        } }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testRoleId = '72abbedc-9853-4fc8-9d28-fa35e207b048'
    $null = $testRoleId
}

Describe 'Get-TeamViewerUserGroupByRole' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerUserGroupByRole -APIToken $testAPIToken -RoleId $testRoleId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/userroles/assignments/usergroups?userRoleId=$testRoleId" -and $Method -eq 'Get'
            }
        }

        It 'Should return assigned groups' {
            $Result = Get-TeamViewerUserGroupByRole -APIToken $testAPIToken -RoleId $testRoleId
            $Result | Should -HaveCount 2
        }
    }
}
