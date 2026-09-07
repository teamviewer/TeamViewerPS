function ConvertTo-TeamViewerUserGroupRoleMembership {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            RoleId = $InputObject
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupRoleMembership')

        Write-Output $Result
    }
}
