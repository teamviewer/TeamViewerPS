function ConvertTo-TeamViewerGroupShare {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id          = $InputObject.userid
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.GroupShare')

        Write-Output $Result
    }
}
