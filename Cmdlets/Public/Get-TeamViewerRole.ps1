function Get-TeamViewerRole {
    [CmdletBinding(DefaultParameterSetName = '')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    Begin{
    $parameters = @{ }
    $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
    }

Process{
    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop
    Write-Output ($response.Roles | ConvertTo-TeamViewerRole )
}
}
