function Get-TeamViewerPredefinedRole {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )


    begin {
        $parameters = @{}
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/predefined"
    }

    process {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($response | ConvertTo-TeamViewerPredefinedRole)
    }
}
