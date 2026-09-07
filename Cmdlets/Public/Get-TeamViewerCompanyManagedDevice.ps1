function Get-TeamViewerCompanyManagedDevice {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.ManagedDevice')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/company"
    $Parameters = @{}

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $Parameters.paginationToken = $Response.nextPaginationToken

        Write-Output ($Response.resources | ConvertTo-TeamViewerManagedDevice)
    } while ($Parameters.paginationToken)
}
