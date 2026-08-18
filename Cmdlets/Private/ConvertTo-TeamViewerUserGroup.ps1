function ConvertTo-TeamViewerUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            Id   = [UInt64]$InputObject.id
            Name = $InputObject.name
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroup')

        Write-Output $Result
    }
}
