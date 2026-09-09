function ConvertTo-TeamViewerDefaultRole {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [object]
        $InputObject
    )

    process {
        $Role_Id = $InputObject.PredefinedUserRoleId

        $Properties = @{
            RoleId = $Role_Id
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.DefaultRole')

        Write-Output $Result
    }
}
