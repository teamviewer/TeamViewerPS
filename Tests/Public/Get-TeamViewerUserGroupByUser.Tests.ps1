BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserGroupByUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerAPIUri { '//unit.test' }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testUserId = 'u123456777'
    $null = $testUserId
}

Describe 'Get-TeamViewerUserGroupByUser' {
    Context 'When retrieving user groups' {
        It 'Should call the user groups API endpoint' {
            Mock Invoke-TeamViewerRestMethod {
                [PSCustomObject]@{
                    nextPaginationToken = $null
                    resources           = @()
                }
            }

            Get-TeamViewerUserGroupByUser -APIToken $testAPIToken -UserId $testUserId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and
                $Uri -eq "//unit.test/users/$testUserId/usergroups" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return converted user groups' {
            Mock Invoke-TeamViewerRestMethod {
                [PSCustomObject]@{
                    nextPaginationToken = $null
                    resources           = @(
                        [PSCustomObject]@{ id = 1001; name = 'Support' }
                        [PSCustomObject]@{ id = 1002; name = 'Sales' }
                    )
                }
            }

            $Result = Get-TeamViewerUserGroupByUser -APIToken $testAPIToken -User $testUserId

            $Result | Should -HaveCount 2
            $Result[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.UserGroup'
            $Result[0].Id | Should -Be 1001
            $Result[0].Name | Should -Be 'Support'
        }

        It 'Should follow pagination without accumulating pagination tokens' {
            $Responses = [System.Collections.Queue]::new()
            $Responses.Enqueue([PSCustomObject]@{
                    nextPaginationToken = 'page 2'
                    resources           = @([PSCustomObject]@{ id = 1001; name = 'Support' })
                })
            $Responses.Enqueue([PSCustomObject]@{
                    nextPaginationToken = $null
                    resources           = @([PSCustomObject]@{ id = 1002; name = 'Sales' })
                })
            Mock Invoke-TeamViewerRestMethod { $Responses.Dequeue() }

            $Result = Get-TeamViewerUserGroupByUser -APIToken $testAPIToken -User $testUserId

            $Result | Should -HaveCount 2
            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $Uri -eq "//unit.test/users/$testUserId/usergroups?paginationToken=page%202"
            }
        }

        It 'Should accept a TeamViewer user object' {
            Mock Invoke-TeamViewerRestMethod {
                [PSCustomObject]@{
                    nextPaginationToken = $null
                    resources           = @()
                }
            }
            $User = [PSCustomObject]@{ Id = $testUserId }
            $User.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

            Get-TeamViewerUserGroupByUser -APIToken $testAPIToken -User $User

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $Uri -eq "//unit.test/users/$testUserId/usergroups"
            }
        }

        It 'Should return no output when the user has no groups' {
            Mock Invoke-TeamViewerRestMethod {
                [PSCustomObject]@{
                    nextPaginationToken = $null
                    resources           = @()
                }
            }

            $Result = @(Get-TeamViewerUserGroupByUser -APIToken $testAPIToken -User $testUserId)

            $Result | Should -HaveCount 0
        }
    }
}
