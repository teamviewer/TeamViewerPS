function ConvertTo-TeamViewerUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id   = [ulong]$InputObject.id
            Name = $InputObject.name
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroup')
        Write-Output $result
    }
}
