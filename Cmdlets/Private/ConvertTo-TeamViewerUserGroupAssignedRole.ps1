function ConvertTo-TeamViewerRoleAssignedUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{AssignedRole = ($InputObject) }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupAssignedRole')
        Write-Output $result
    }
}
