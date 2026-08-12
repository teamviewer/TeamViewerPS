function ConvertTo-TeamViewerRoleAssignedUser {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            AssignedUsers = ($InputObject.trim('u'))
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleAssignedUser')

        $result
    }
}
