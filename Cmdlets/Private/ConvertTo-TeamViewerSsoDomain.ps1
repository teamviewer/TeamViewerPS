function ConvertTo-TeamViewerSsoDomain {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            Id   = $InputObject.DomainId
            Name = $InputObject.DomainName
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.SsoDomain')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.Name)"
        }

        Write-Output $Result
    }
}
