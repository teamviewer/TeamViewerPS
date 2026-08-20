function ConvertTo-TeamViewerLicense {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            CompanyId         = [int]$InputObject.companyId
            CompanyName       = $InputObject.companyName
            AvailableLicenses = @($InputObject.available_licenses | ConvertTo-TeamViewerLicenseInformation)
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.License')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.CompanyName)"
        }

        Write-Output $Result
    }
}
