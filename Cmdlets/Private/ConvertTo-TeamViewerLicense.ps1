function ConvertTo-TeamViewerLicense {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            CompanyId         = [int]$InputObject.companyId
            CompanyName       = $InputObject.companyName
            AvailableLicenses = @($InputObject.available_licenses | ConvertTo-TeamViewerLicenseInformation)
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.License')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.CompanyName)"
        }

        $result
    }
}
