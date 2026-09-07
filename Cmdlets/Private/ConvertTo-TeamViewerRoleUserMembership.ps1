function ConvertTo-TeamViewerRoleUserMembership {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            UserId = $InputObject
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleUserMembership')

        Write-Output $Result
    }
}
