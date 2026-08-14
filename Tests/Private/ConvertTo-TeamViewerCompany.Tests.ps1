BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private')

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerCompany.ps1')
}

Describe 'ConvertTo-TeamViewerCompany' {
    Context 'Property mapping' {
        It 'Should map company properties including CreatedAt when present' {
            $companyInput = [pscustomobject]@{
                companyId   = '42'
                companyName = 'Acme Corp'
                createdAt   = '2026-08-10T12:34:56Z'
            }

            $result = $companyInput | ConvertTo-TeamViewerCompany

            $result.CompanyId | Should -Be 42
            $result.CompanyName | Should -Be 'Acme Corp'
            $result.CreatedAt | Should -Be ([datetime]'2026-08-10T12:34:56Z')
        }

        It 'Should keep CreatedAt null when not present in input' {
            $companyInput = [pscustomobject]@{
                companyId   = 7
                companyName = 'No Date Ltd'
            }

            $result = $companyInput | ConvertTo-TeamViewerCompany

            $result.CreatedAt | Should -BeNull
        }

        It 'Should return null CreatedAt when createdAt is invalid: <CreatedAt>' -TestCases @(
            @{ CreatedAt = 'invalid-date' }
            @{ CreatedAt = ' ' }
            @{ CreatedAt = '' }
            @{ CreatedAt = $null }
        ) {
            param(
                [AllowNull()]
                [string]$CreatedAt
            )

            $companyInput = [pscustomobject]@{
                companyId   = 9
                companyName = 'Date Test'
                createdAt   = $CreatedAt
            }

            $result = $companyInput | ConvertTo-TeamViewerCompany

            $result.CreatedAt | Should -BeNull
        }

        It 'Should cast companyId to integer' {
            $companyInput = [pscustomobject]@{
                companyId   = '7'
                companyName = 'Numeric Cast'
            }

            $result = $companyInput | ConvertTo-TeamViewerCompany

            $result.CompanyId | Should -Be 7
            $result.CompanyId.GetType().Name | Should -Be 'Int32'
        }
    }

    Context 'Output shape and type metadata' {
        It 'Should expose expected output properties' {
            $companyInput = [pscustomobject]@{
                companyId   = 5
                companyName = 'Contoso'
            }

            $result = $companyInput | ConvertTo-TeamViewerCompany

            $result.PSObject.Properties.Name | Should -Contain 'CompanyId'
            $result.PSObject.Properties.Name | Should -Contain 'CompanyName'
            $result.PSObject.Properties.Name | Should -Contain 'CreatedAt'
        }

        It 'Should expose TeamViewerPS.Company type name and custom ToString output' {
            $companyInput = [pscustomobject]@{
                companyId   = 5
                companyName = 'Contoso'
            }

            $result = $companyInput | ConvertTo-TeamViewerCompany

            $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Company'
            $result.ToString() | Should -Be 'Contoso'
        }
    }

    Context 'Pipeline behavior' {
        It 'Should process multiple pipeline inputs independently' {
            $inputObjects = @(
                [pscustomobject]@{ companyId = 1; companyName = 'Alpha'; createdAt = '2026-08-10T00:00:00Z' }
                [pscustomobject]@{ companyId = 2; companyName = 'Beta' }
            )

            $results = $inputObjects | ConvertTo-TeamViewerCompany

            @($results).Count | Should -Be 2
            $results[0].CompanyName | Should -Be 'Alpha'
            $results[1].CompanyName | Should -Be 'Beta'
            $results[1].CreatedAt | Should -BeNull
        }
    }
}
