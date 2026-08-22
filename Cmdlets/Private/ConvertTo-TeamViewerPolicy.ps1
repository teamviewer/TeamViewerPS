function ConvertTo-TeamViewerPolicy {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
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

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Policy')

        Write-Output $Result
    }
}
