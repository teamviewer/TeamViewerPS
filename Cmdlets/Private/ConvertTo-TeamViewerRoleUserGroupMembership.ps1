function ConvertTo-TeamViewerRoleUserGroupMembership {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            UserGroupId = $InputObject
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleUserGroupMembership')

        Write-Output $Result
    }
}
