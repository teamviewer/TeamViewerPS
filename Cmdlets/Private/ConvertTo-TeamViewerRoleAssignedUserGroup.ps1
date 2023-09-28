function ConvertTo-TeamViewerRoleAssignedUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{AssignedGroups = ($InputObject)}
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleAssignedUserGroup')
        Write-Output $result
    }
}
