function Get-TeamViewerSsoDomain {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,
        
        [Parameter(ParameterSetName = "ByDomainId")]
        [Alias("DomainId")]
        [guid]
        $Id
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain";
    $parameters = @{ }
    switch ($PsCmdlet.ParameterSetName) {
        'ByDomainId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop
    Write-Output ($response.domains | ConvertTo-TeamViewerSsoDomain)
}
