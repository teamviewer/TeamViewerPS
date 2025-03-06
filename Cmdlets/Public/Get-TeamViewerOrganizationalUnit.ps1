function Get-TeamViewerOrganizationalUnit {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerOrganizationalUnitId } )]
        [Alias('OrganizationalUnitId')]
        [Alias('Id')]
        [object]
        $OrganizationalUnit
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/organizationalunits"
        $parameters = @{ }

        if ($OrganizationalUnit) {
            $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
            $resourceUri += "/$OrganizationalUnitId"
            $parameters = $null
        }
    }

    Process {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($response | ConvertTo-TeamViewerOrganizationalUnit)
    }
}
