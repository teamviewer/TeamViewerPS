BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDefaultRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{ PredefineduserRoleId = 'e1631449-6321-4a58-920c-5440029b092e' }
    }
}

Describe 'Get-TeamViewerDefaultRole' {
    It 'Should call the correct API endpoint to list DefaultRole' {
        Get-TeamViewerDefaultRole -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/userroles/predefined' -and $Method -eq 'Get' }
    }

    It 'Should convert input object to TeamViewerPS.DefaultRole' {
        $InputObject = @{
            PredefineduserRoleId = 'a9c9435d-8544-4e6a-9830-9337078c9aab'
        } | ConvertTo-Json

        $Result = $InputObject | ConvertFrom-Json | ConvertTo-TeamViewerDefaultRole

        $Result | Should -BeOfType [PSCustomObject]
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.DefaultRole'
        $Result.Role_Id | Should -Be 'a9c9435d-8544-4e6a-9830-9337078c9aab'
    }

    It 'Should return DefaultRole objects' {
        $Result = Get-TeamViewerDefaultRole -APIToken $testAPIToken
        $Result | Should -HaveCount 1
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.DefaultRole'
    }
}
