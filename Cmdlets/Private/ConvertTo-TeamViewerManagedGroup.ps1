function ConvertTo-TeamViewerManagedGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            Id   = [guid]$InputObject.id
            Name = $InputObject.name
        }

        if ($InputObject.policy_id) {
            $Properties['PolicyId'] = $InputObject.policy_id
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedGroup')

        Write-Output $Result
    }
}
