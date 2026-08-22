function ConvertTo-TeamViewerRoleAssignedUser {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            User_Id = $InputObject
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleAssignedUser')

        Write-Output $Result
    }
}
