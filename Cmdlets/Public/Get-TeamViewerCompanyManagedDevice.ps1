function Get-TeamViewerCompanyManagedDevice {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/company"
    $parameters = @{}

    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $parameters.paginationToken = $response.nextPaginationToken
        Write-Output ($response.resources | ConvertTo-TeamViewerManagedDevice)
    } while ($parameters.paginationToken)
}
