BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'New-TeamViewerOrganizationalUnit' {
    # Mock the required functions
    Mock -CommandName Get-TeamViewerApiUri -MockWith { return 'https://api.teamviewer.com/v1' }
    Mock -CommandName Invoke-TeamViewerRestMethod -MockWith { return @{ id = 'mocked-id'; name = 'Mocked OU' } }
    Mock -CommandName ConvertTo-TeamViewerOrganizationalUnit -MockWith { param($InputObj) return $InputObj }

    Context 'When called with mandatory parameters' {
        It 'should construct the correct URI and body' {
            $params = @{
                ApiToken = [securestring]@{}
                Name     = 'Mocked OU'
            }

            New-TeamViewerOrganizationalUnit @params

            # Verify the URI and body construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits' -and
                $Body.name -eq 'Mocked OU' -and
                $Body.description -eq $null -and
                $Body.parentId -eq $null
            }
        }
    }

    Context 'When called with optional parameters' {
        It 'should construct the correct URI and body with optional parameters' {
            $params = @{
                ApiToken    = [securestring]@{}
                Name        = 'Mocked OU'
                Description = 'Mocked Description'
                ParentId    = 'mocked-parent-id'
            }

            New-TeamViewerOrganizationalUnit @params

            # Verify the URI and body construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits' -and
                $Body.name -eq 'Mocked OU' -and
                $Body.description -eq 'Mocked Description' -and
                $Body.parentId -eq 'mocked-parent-id'
            }
        }
    }

    Context 'When an error occurs' {
        It 'should handle the error and write an error message' {
            Mock -CommandName Invoke-TeamViewerRestMethod -MockWith { throw 'Mocked error' }

            $params = @{
                ApiToken = [securestring]@{}
                Name     = 'Mocked OU'
            }

            { New-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Failed to create organizational unit: Mocked error'
        }
    }

    Context 'When called with invalid parameters' {
        It 'should throw a validation error' {
            $params = @{
                ApiToken = [securestring]@{}
                Name     = ''  # Invalid value, should not be empty
            }

            { New-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Cannot validate argument on parameter'
        }
    }

    Context 'When ShouldProcess is supported' {
        It 'should call ShouldProcess and proceed if confirmed' {
            Mock -CommandName $PSCmdlet.ShouldProcess -MockWith { return $true }

            $params = @{
                ApiToken = [securestring]@{}
                Name     = 'Mocked OU'
            }

            New-TeamViewerOrganizationalUnit @params

            # Verify ShouldProcess was called
            Assert-MockCalled -CommandName $PSCmdlet.ShouldProcess -Exactly 1 -Scope It
        }
    }

    Context 'When ShouldProcess is not confirmed' {
        It 'should not proceed with the creation' {
            Mock -CommandName $PSCmdlet.ShouldProcess -MockWith { return $false }

            $params = @{
                ApiToken = [securestring]@{}
                Name     = 'Mocked OU'
            }

            New-TeamViewerOrganizationalUnit @params

            # Verify Invoke-TeamViewerRestMethod was not called
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Times 0 -Scope It
        }
    }

    Context 'When called with a long description' {
        It 'should handle the long description correctly' {
            $longDescription = 'A' * 300  # Maximum length description
            $params = @{
                ApiToken    = [securestring]@{}
                Name        = 'Mocked OU'
                Description = $longDescription
            }

            New-TeamViewerOrganizationalUnit @params

            # Verify the URI and body construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits' -and
                $Body.name -eq 'Mocked OU' -and
                $Body.description -eq $longDescription
            }
        }
    }
}
