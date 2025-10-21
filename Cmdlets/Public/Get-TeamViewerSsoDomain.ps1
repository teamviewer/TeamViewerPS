function Get-TeamViewerSsoDomain {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,
        
        [Parameter(ParameterSetName = "ById")]
        [Alias("Id")]
        [guid]
        $Id
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain";
    $parameters = @{ }
    switch ($PsCmdlet.ParameterSetName) {
        'ById' {
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
