BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerOrganizationalUnit.ps1')
}

Describe 'ConvertTo-TeamViewerOrganizationalUnit' {
    It 'Returns an object for pipeline input' {
        $InputObject = [pscustomobject]@{
            id          = ([guid]::NewGuid().ToString())
            name        = 'Sample'
            description = 'A sample organizational unit'
            parentId    = ([guid]::NewGuid().ToString())
            createdAt   = '2023-01-01T00:00:00Z'
            updatedAt   = '2023-01-02T00:00:00Z'
        }

        $Result = $InputObject | & ConvertTo-TeamViewerOrganizationalUnit

        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.OrganizationalUnit'
    }

    It 'Maps the API fields to the object properties' {
        $Id = [guid]::NewGuid().ToString()
        $ParentId = [guid]::NewGuid().ToString()
        $InputObject = [pscustomobject]@{
            id          = $Id
            name        = 'Sample'
            description = 'A sample organizational unit'
            parentId    = $ParentId
            createdAt   = '2023-01-01T00:00:00Z'
            updatedAt   = '2023-01-02T00:00:00Z'
        }

        $Result = $InputObject | & ConvertTo-TeamViewerOrganizationalUnit

        $Result.Id | Should -Be $Id
        $Result.Name | Should -Be 'Sample'
        $Result.Description | Should -Be 'A sample organizational unit'
        $Result.ParentId | Should -Be $ParentId
        $Result.CreatedAt | Should -Be '2023-01-01T00:00:00Z'
        $Result.UpdatedAt | Should -Be '2023-01-02T00:00:00Z'
    }

    It 'Supports pipeline processing of multiple items' {
        $InputObjects = @(
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'One' },
            [pscustomobject]@{ id = ([guid]::NewGuid().ToString()); name = 'Two' }
        )

        $Result = $InputObjects | & ConvertTo-TeamViewerOrganizationalUnit

        @($Result).Count | Should -Be 2
    }
}
