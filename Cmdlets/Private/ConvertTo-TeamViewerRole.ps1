function ConvertTo-TeamViewerRole {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id          = $InputObject.Id
            Name        = $InputObject.Name
            Permissions = $InputObject.Permissions
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Role')

        Write-Output $Result
    }
}
