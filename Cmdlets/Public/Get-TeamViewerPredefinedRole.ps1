function Get-TeamViewerPredefinedRole {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )


    Begin {
        $parameters = @{}
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/predefined"
    }

    Process {
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
