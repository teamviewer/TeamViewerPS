BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerCompany.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            companyId   = 42
            companyName = 'TeamViewer Germany GmbH'
        }
    }
}

Describe 'Get-TeamViewerCompany' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerCompany -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/company' -and $Method -eq 'Get' }
    }

    It 'Should return Company object' {
        $Result = Get-TeamViewerCompany -APIToken $testAPIToken
        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Company'
        $Result.Id | Should -Be 42
        $Result.Name | Should -Be 'TeamViewer Germany GmbH'
    }
}
