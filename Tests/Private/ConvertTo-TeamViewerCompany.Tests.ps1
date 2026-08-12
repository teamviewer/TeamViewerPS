BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-DateTime.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerCompany.ps1"
}

Describe 'ConvertTo-TeamViewerCompany' {
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
