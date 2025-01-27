function Get-TeamViewerOrganizationalUnit {
    [CmdletBinding(DefaultParameterSetName = 'ByOrganizationalUnitId')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByOrganizationalUnitId')]
        [Alias('OrganizationalUnitId')]
        [string]
        $Id,

        [Parameter(ParameterSetName = 'FilteredList')]
        [Alias('PartialName')]
        [string]
        $Name
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/organizationalunits"
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByOrganizationalUnitId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $parameters['name'] = $Name
            }
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    if ($PsCmdlet.ParameterSetName -eq 'ByOrganizationalUnitId') {
        Write-Output ($response | ConvertTo-TeamViewerOrganizationalUnit)
    }
    else {
        # ToDo
        Write-Output ($response.organizationalunits | ConvertTo-TeamViewerOrganizationalUnit)
    }
}
