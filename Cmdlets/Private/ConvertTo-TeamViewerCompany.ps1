function ConvertTo-TeamViewerCompany {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id        = [int32]$InputObject.companyId
            Name      = [string]$InputObject.companyName
            CreatedAt = $null
        }

        if ($InputObject.createdAt) {
            $Properties['CreatedAt'] = ($InputObject.createdAt | ConvertTo-DateTime)
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Company')

        Write-Output $Result
    }
}
