BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Set-TeamViewerOrganizationalUnit' {
    # Mock the required functions
    Mock -CommandName Get-TeamViewerApiUri -MockWith { return 'https://api.teamviewer.com/v1' }
    Mock -CommandName Resolve-TeamViewerOrganizationalUnitId -MockWith { return 'mocked-id' }
    Mock -CommandName Invoke-TeamViewerRestMethod -MockWith { return @{ id = 'mocked-id'; name = 'Updated OU' } }
    Mock -CommandName ConvertTo-TeamViewerOrganizationalUnit -MockWith { param($InputObj) return $InputObj }

    Context 'When called with mandatory parameters' {
        It 'should construct the correct URI and body' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Set-TeamViewerOrganizationalUnit @params

            # Verify the URI and body construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits/mocked-id' -and
                $Body.name -eq $null -and
                $Body.description -eq $null -and
                $Body.parentId -eq $null
            }
        }
    }

    Context 'When called with optional parameters' {
        It 'should construct the correct URI and body with optional parameters' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
                Name               = 'Updated OU'
                Description        = 'Updated Description'
                ParentId           = 'mocked-parent-id'
            }

            Set-TeamViewerOrganizationalUnit @params

            # Verify the URI and body construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits/mocked-id' -and
                $Body.name -eq 'Updated OU' -and
                $Body.description -eq 'Updated Description' -and
                $Body.parentId -eq 'mocked-parent-id'
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

            { Set-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Failed to change organizational unit: Mocked error'
        }
    }

    Context 'When called with invalid parameters' {
        It 'should throw a validation error' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
                Name               = ''  # Invalid value, should not be empty
            }

            { Set-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Cannot validate argument on parameter'
        }
    }

    Context 'When ShouldProcess is supported' {
        It 'should call ShouldProcess and proceed if confirmed' {
            Mock -CommandName $PSCmdlet.ShouldProcess -MockWith { return $true }

            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Set-TeamViewerOrganizationalUnit @params

            # Verify ShouldProcess was called
            Assert-MockCalled -CommandName $PSCmdlet.ShouldProcess -Exactly 1 -Scope It
        }
    }

    Context 'When ShouldProcess is not confirmed' {
        It 'should not proceed with the update' {
            Mock -CommandName $PSCmdlet.ShouldProcess -MockWith { return $false }

            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Set-TeamViewerOrganizationalUnit @params

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

            Set-TeamViewerOrganizationalUnit @params

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

            { Set-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Resolution error'
        }
    }

    Context 'When called with a long description' {
        It 'should handle the long description correctly' {
            $longDescription = 'A' * 300  # Maximum length description
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
                Description        = $longDescription
            }

            Set-TeamViewerOrganizationalUnit @params

            # Verify the URI and body construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits/mocked-id' -and
                $Body.description -eq $longDescription
            }
        }
    }
}
