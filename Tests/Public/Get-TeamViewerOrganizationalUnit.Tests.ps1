BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerOrganizationalUnit' {
    # Mock the required functions
    Mock -CommandName Get-TeamViewerApiUri -MockWith { return 'https://api.teamviewer.com/v1' }
    Mock -CommandName Resolve-TeamViewerOrganizationalUnitId -MockWith { return 'mocked-id' }
    Mock -CommandName Invoke-TeamViewerRestMethod -MockWith { return @{ id = 'mocked-id'; name = 'Mocked OU' } }
    Mock -CommandName ConvertTo-TeamViewerOrganizationalUnit -MockWith { param($InputObj) return $InputObj }

    Context 'When called with ParameterSetName List' {
        It 'should construct the correct URI and body' {
            $params = @{
                ApiToken   = [securestring]@{}
                Recursive  = $true
                ParentId   = 'mocked-parent-id'
                Filter     = 'mocked-filter'
                SortBy     = 'Name'
                SortOrder  = 'Asc'
                PageSize   = 100
                PageNumber = 1
            }

            Get-TeamViewerOrganizationalUnit @params

            # Verify the URI construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits' -and
                $Body.includeChildren -eq $true -and
                $Body.startOrganizationalUnitId -eq 'mocked-parent-id' -and
                $Body.filter -eq 'mocked-filter' -and
                $Body.sortBy -eq 'Name' -and
                $Body.sortOrder -eq 'Asc' -and
                $Body.pageSize -eq 100 -and
                $Body.pageNumber -eq 1
            }
        }
    }

    Context 'When called with ParameterSetName ById' {
        It 'should construct the correct URI without body' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Get-TeamViewerOrganizationalUnit @params -ParameterSetName 'ById'

            # Verify the URI construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits/mocked-id' -and
                $Body -eq $null
            }
        }
    }

    Context 'When an error occurs' {
        It 'should handle the error and write an error message' {
            Mock -CommandName Invoke-TeamViewerRestMethod -MockWith { throw 'Mocked error' }

            $params = @{
                ApiToken  = [securestring]@{}
                Recursive = $true
            }

            { Get-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Failed to get organizational unit: Mocked error'
        }
    }

    Context 'When called with minimal parameters' {
        It 'should construct the correct URI and default body' {
            $params = @{
                ApiToken = [securestring]@{}
            }

            Get-TeamViewerOrganizationalUnit @params

            # Verify the URI construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits' -and
                $Body.sortBy -eq 'Name' -and
                $Body.sortOrder -eq 'Asc' -and
                $Body.pageSize -eq 100 -and
                $Body.pageNumber -eq 1
            }
        }
    }

    Context 'When called with custom sorting and pagination' {
        It 'should construct the correct URI and body with custom parameters' {
            $params = @{
                ApiToken   = [securestring]@{}
                SortBy     = 'CreatedAt'
                SortOrder  = 'Desc'
                PageSize   = 200
                PageNumber = 2
            }

            Get-TeamViewerOrganizationalUnit @params

            # Verify the URI construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits' -and
                $Body.sortBy -eq 'CreatedAt' -and
                $Body.sortOrder -eq 'Desc' -and
                $Body.pageSize -eq 200 -and
                $Body.pageNumber -eq 2
            }
        }
    }

    Context 'When called with invalid parameters' {
        It 'should throw a validation error' {
            $params = @{
                ApiToken = [securestring]@{}
                PageSize = 300  # Invalid value, should be between 50 and 250
            }

            { Get-TeamViewerOrganizationalUnit @params } | Should -Throw -ErrorMessage 'Cannot validate argument on parameter'
        }
    }

    Context 'When called with a valid OrganizationalUnitId' {
        It 'should resolve the OrganizationalUnitId and construct the correct URI' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = 'mocked-ou'
            }

            Get-TeamViewerOrganizationalUnit @params -ParameterSetName 'ById'

            # Verify the URI construction
            Assert-MockCalled -CommandName Invoke-TeamViewerRestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq 'https://api.teamviewer.com/v1/organizationalunits/mocked-id' -and
                $Body -eq $null
            }
        }
    }

    Context 'When called with a null OrganizationalUnitId' {
        It 'should throw an error' {
            $params = @{
                ApiToken           = [securestring]@{}
                OrganizationalUnit = $null
            }

            { Get-TeamViewerOrganizationalUnit @params -ParameterSetName 'ById' } | Should -Throw -ErrorMessage 'Cannot bind argument to parameter'
        }
    }
}
