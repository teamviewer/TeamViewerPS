function Get-TeamViewerSsoInclusion {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias('Domain')]
        [object]
        $DomainId
    )

    $id = $DomainId | Resolve-TeamViewerSsoDomainId
    $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$id/inclusion"
    $parameters = @{ }
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output $response.emails
        $parameters.ct = $response.continuation_token
    } while ($parameters.ct)
}
