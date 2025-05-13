BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRoleByUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            assignedRoleId = 15
        } }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '113456'
    $null = $testGroupId
}

Describe 'Get-TeamViewerUserGroupByRole' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerRoleByUserGroup -ApiToken $testApiToken -GroupId $testGroupId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/usergroups/$testGroupId/userroles" -And `
                    $Method -eq 'Get'
            }
        }

        It 'Should return assigned groups' {
            $result = Get-TeamViewerRoleByUserGroup -ApiToken $testApiToken -GroupId $testGroupId
            $result | Should -HaveCount 1
        }

    }
}
