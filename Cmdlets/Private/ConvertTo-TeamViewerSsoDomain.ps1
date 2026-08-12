function ConvertTo-TeamViewerSsoDomain {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            Id   = $InputObject.DomainId
            Name = $InputObject.DomainName
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.SsoDomain')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.Name)"
        }

        $result
    }
}
