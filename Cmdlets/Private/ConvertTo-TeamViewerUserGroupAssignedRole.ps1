function ConvertTo-TeamViewerUserGroupAssignedRole {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            UserGroup_Id = $InputObject
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupAssignedRole')

        Write-Output $Result
    }
}
