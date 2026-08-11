function ConvertTo-DateTime {
    param(
        [Parameter(ValueFromPipeline)]
        [string]
        $InputString
    )

    process {
        try {
            [DateTime]::Parse($InputString)
        }
        catch [System.ArgumentNullException], [System.FormatException] {
            $null
        }
    }
}
