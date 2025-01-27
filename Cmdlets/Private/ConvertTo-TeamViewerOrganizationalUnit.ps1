function ConvertTo-TeamViewerOrganizationalUnit {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id          = $InputObject.id
            Name        = $InputObject.name
            Description = $InputObject.description
            ParentId    = $InputObject.parentid
            CreatedAt   = $InputObject.createdat
            UpdatedAt   = $InputObject.updatedat
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.OrganizationalUnit')

        Write-Output $result
    }
}
