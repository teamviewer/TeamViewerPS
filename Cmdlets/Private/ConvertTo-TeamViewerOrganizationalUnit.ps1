function ConvertTo-TeamViewerOrganizationalUnit {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject]
        $InputObject
    )

    process {
        # Extract properties from the input object
        $properties = @{
            Id          = $InputObject.id
            Name        = $InputObject.name
            Description = $InputObject.description
            ParentId    = $InputObject.parentId
            CreatedAt   = $InputObject.createdAt
            UpdatedAt   = $InputObject.updatedAt
        }

        # Create a new object with the extracted properties
        $Result = New-Object -TypeName PSObject -Property $properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.OrganizationalUnit')

        Write-Output $Result
    }
}
