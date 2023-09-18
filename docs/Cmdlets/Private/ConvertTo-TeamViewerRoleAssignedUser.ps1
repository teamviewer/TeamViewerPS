function ConvertTo-TeamViewerRoleAssignedUser {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{AssignedUsers = ($InputObject.trim('u'))}
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleAssignedUser')
        Write-Output $result
    }
}
