function ConvertTo-TeamViewerRoleAssignedUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            AssignedGroups = ($InputObject)
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupAssignedRole')

        $result
    }
}
