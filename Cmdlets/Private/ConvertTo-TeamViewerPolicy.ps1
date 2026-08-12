function ConvertTo-TeamViewerPolicy {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            Id       = $InputObject.policy_id
            Name     = $InputObject.name
            Settings = @(
                $InputObject.settings | ForEach-Object {
                    @{
                        Key     = $_.key
                        Value   = $_.value
                        Enforce = $_.enforce
                    }
                }
            )
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Policy')

        $result
    }
}
