function ConvertTo-TeamViewerUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            Id   = [UInt64]$InputObject.id
            Name = $InputObject.name
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroup')

        $result
    }
}
