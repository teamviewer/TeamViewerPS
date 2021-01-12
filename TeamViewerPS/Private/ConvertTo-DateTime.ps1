function ConvertTo-DateTime {
    param(
        [Parameter(ValueFromPipeline)]
        [string]
        $InputString
    )

    process {
        try {
            Write-Output ([DateTime]::Parse($InputString))
        }
        catch {
            Write-Output $null
        }
    }
}