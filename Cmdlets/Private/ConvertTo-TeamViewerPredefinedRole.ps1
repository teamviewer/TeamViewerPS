function ConvertTo-TeamViewerPredefinedRole {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Role_Id = $InputObject.PredefinedUserRoleId
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.PredefinedRole')

        Write-Output $Result
    }
}
