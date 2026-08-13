function ConvertTo-TeamViewerCompany {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $properties = @{
            CompanyId   = [int]$InputObject.companyId
            CompanyName = $InputObject.companyName
            CreatedAt   = $null
        }

        if ($InputObject.createdAt) {
            $properties['CreatedAt'] = $InputObject.createdAt | ConvertTo-DateTime
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Company')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.CompanyName)"
        }

        $result
    }
}
