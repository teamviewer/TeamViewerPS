function ConvertTo-TeamViewerCompany {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            CompanyId   = [int]$InputObject.companyId
            CompanyName = $InputObject.companyName
            CreatedAt   = $null
        }

        if ($InputObject.createdAt) {
            $Properties['CreatedAt'] = $InputObject.createdAt | ConvertTo-DateTime
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Company')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.CompanyName)"
        }

        Write-Output $Result
    }
}
