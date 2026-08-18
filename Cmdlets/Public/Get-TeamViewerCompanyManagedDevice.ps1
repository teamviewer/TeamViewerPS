function Get-TeamViewerCompanyManagedDevice {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.ManagedDevice')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/company"
    $Parameters = @{}

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $Parameters.paginationToken = $Response.nextPaginationToken

        Write-Output ($Response.resources | ConvertTo-TeamViewerManagedDevice)
    } while ($Parameters.paginationToken)
}
