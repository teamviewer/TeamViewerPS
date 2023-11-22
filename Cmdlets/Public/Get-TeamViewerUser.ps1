function Get-TeamViewerUser {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByUserId')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('UserId')]
        [string]
        $Id,

        [Parameter(ParameterSetName = 'FilteredList')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'FilteredList')]
        [string[]]
        $Email,

        [Parameter(ParameterSetName = "FilteredList")]
        [string[]]
        $Permissions,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $PropertiesToLoad = 'All'
    )

    $parameters = @{ }
    switch ($PropertiesToLoad) {
        'All' {
            $parameters.full_list = $true
        }
        'Minimal' {
        }
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/users"

    switch ($PsCmdlet.ParameterSetName) {
        'ByUserId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $parameters['name'] = $Name
            }

            if ($Email) {
                $parameters['email'] = ($Email -join ',')
            }
            if ($Permissions) {
                $parameters['permissions'] = ($Permissions -join ',')
            }
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken -Uri $resourceUri -Method Get -Body $parameters -WriteErrorTo $PSCmdlet -ErrorAction Stop

    if ($PsCmdlet.ParameterSetName -Eq 'ByUserId') {
        Write-Output ($response | ConvertTo-TeamViewerUser -PropertiesToLoad $PropertiesToLoad)
    }
    else {
        Write-Output ($response.users | ConvertTo-TeamViewerUser -PropertiesToLoad $PropertiesToLoad)
    }
}
