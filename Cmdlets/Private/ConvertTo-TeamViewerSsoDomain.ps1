function ConvertTo-TeamViewerSSODomain {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id   = $InputObject.DomainId
            Name = $InputObject.DomainName
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.SSODomain')

        Write-Output $Result
    }
}
