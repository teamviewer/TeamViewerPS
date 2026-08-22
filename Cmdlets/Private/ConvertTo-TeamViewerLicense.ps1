function ConvertTo-TeamViewerLicense {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id                 = [int]$InputObject.companyId
            Name               = $InputObject.companyName
            Licenses_Available = @($InputObject.available_licenses | ConvertTo-TeamViewerLicenseInformation)
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.License')

        Write-Output $Result
    }
}
