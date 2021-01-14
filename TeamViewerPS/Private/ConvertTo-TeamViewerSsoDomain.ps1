function ConvertTo-TeamViewerSsoDomain {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id   = $InputObject.DomainId
            Name = $InputObject.DomainName
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.SsoDomain')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name)"
        }
        Write-Output $result
    }
}
