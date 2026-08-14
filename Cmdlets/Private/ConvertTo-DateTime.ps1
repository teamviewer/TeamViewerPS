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
        catch [System.ArgumentNullException], [System.FormatException] {
            Write-Output $null
        }
    }
}
