function ConvertTo-TeamViewerManagedGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            Id   = [guid]$InputObject.id
            Name = $InputObject.name
        }

        if ($InputObject.policy_id) {
            $properties['PolicyId'] = $InputObject.policy_id
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedGroup')

        $result
    }
}
