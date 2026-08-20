function ConvertTo-TeamViewerRoleAssignedUser {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Assigned_Users = ($InputObject.trim('u'))
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleAssignedUser')

        Write-Output $Result
    }
}
