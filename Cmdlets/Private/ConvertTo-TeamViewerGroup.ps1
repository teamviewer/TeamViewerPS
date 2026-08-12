function ConvertTo-TeamViewerGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            Id          = $InputObject.id
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
            PolicyId    = $InputObject.policy_id
            SharedWith  = @($InputObject.shared_with | ConvertTo-TeamViewerGroupShare)
        }

        if ($InputObject.owner) {
            $properties.Owner = [pscustomobject]@{
                UserId = $InputObject.owner.userid
                Name   = $InputObject.owner.name
            }
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Group')

        $result
    }
}
