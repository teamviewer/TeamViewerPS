function ConvertTo-TeamViewerGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id          = $InputObject.id
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
            SharedWith  = @($InputObject.shared_with | ConvertTo-TeamViewerGroupShare)
        }
        if ($InputObject.owner) {
            $properties.Owner = [pscustomobject]@{
                UserId = $InputObject.owner.userid
                Name   = $InputObject.owner.name
            }
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Group')
        Write-Output $result
    }
}