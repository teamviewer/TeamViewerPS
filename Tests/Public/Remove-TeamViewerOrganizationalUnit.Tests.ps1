BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}


Describe 'Remove-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint' {
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $testOrganizationalUnitId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                $Method -eq 'Delete'
        }
    }

    It 'Should handle domain object as input' {
        $testOrganizationalUnit = @{Id = $testOrganizationalUnitId } | ConvertTo-TeamViewerOrganizationalUnit
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $testOrganizationalUnit

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                $Method -eq 'Delete'
        }
    }
}
Describe 'Remove-TeamViewerOrganizationalUnit' {
    # Mock the required functions
    Mock -CommandName Get-TeamViewerApiUri -MockWith { return 'https://api.teamviewer.com/v1' }
    Mock -CommandName Resolve-TeamViewerOrganizationalUnitId -MockWith { return 'mocked-id' }
    Mock -CommandName Invoke-TeamViewerRestMethod -MockWith { return $null }

    Context 'When called with mandatory parameters' {
        It 'should construct the correct URI' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Remove-TeamViewerOrganizationalUnit @params

            # Verify the URI construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits/mocked-id'
            }
        }
    }

    Context 'When an error occurs' {
        It 'should handle the error and write an error message' {
            Mock -CommandName Invoke-TeamViewerRestMethod -MockWith { throw 'Mocked error' }

            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            { Remove-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Failed to remove organizational unit: Mocked error'
        }
    }

    Context 'When called with invalid parameters' {
        It 'should throw a validation error' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = $null  # Invalid value, should not be null
            }

            { Remove-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Cannot validate argument on parameter'
        }
    }

    Context 'When ShouldProcess is supported' {
        It 'should call ShouldProcess and proceed if confirmed' {
            Mock -CommandName $PSCmdlet.ShouldProcess -MockWith { return $true }

            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Remove-TeamViewerOrganizationalUnit @params

            # Verify ShouldProcess was called
            Assert-MockCalled -CommandName $PSCmdlet.ShouldProcess -Exactly 1 -Scope It
        }
    }

    Context 'When ShouldProcess is not confirmed' {
        It 'should not proceed with the removal' {
            Mock -CommandName $PSCmdlet.ShouldProcess -MockWith { return $false }

            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Remove-TeamViewerOrganizationalUnit @params

            # Verify Invoke-TeamViewerRestMethod was not called
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Times 0 -Scope It
        }
    }

    Context 'When OrganizationalUnitId is resolved correctly' {
        It 'should resolve the OrganizationalUnitId and construct the correct URI' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Remove-TeamViewerOrganizationalUnit @params

            # Verify the URI construction
            Assert-MockCalled -CommandName Resolve-TeamViewerOrganizationalUnitId -Exactly 1 -Scope It
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits/mocked-id'
            }
        }
    }

    Context 'When OrganizationalUnitId resolution fails' {
        It 'should handle the resolution failure and write an error message' {
            Mock -CommandName Resolve-TeamViewerOrganizationalUnitId -MockWith { throw 'Resolution error' }

            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            { Remove-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Resolution error'
        }
    }
}
