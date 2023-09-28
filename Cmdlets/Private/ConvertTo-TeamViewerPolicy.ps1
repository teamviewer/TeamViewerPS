function ConvertTo-TeamViewerPolicy {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
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

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Policy')
        Write-Output $result
    }
}
