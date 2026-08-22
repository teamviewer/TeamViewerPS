function Get-TeamViewerUser {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.User')]

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

        [Parameter(ParameterSetName = 'FilteredList')]
        [string[]]
        $Permissions,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $PropertiesToLoad = 'All'
    )

    $Parameters = @{ }
    switch ($PropertiesToLoad) {
        'All' {
            $Parameters.full_list = $true
        }
        'Minimal' {
        }
    }

    $ResourceUri = "$(Get-TeamViewerApiUri)/users"

    switch ($PsCmdlet.ParameterSetName) {
        'ByUserId' {
            $ResourceUri += "/$Id"
            $Parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $Parameters['name'] = $Name
            }

            if ($Email) {
                $Parameters['email'] = ($Email -join ',')
            }
            if ($Permissions) {
                $Parameters['permissions'] = ($Permissions -join ',')
            }
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken -Uri $ResourceUri -Method Get -Body $Parameters -WriteErrorTo $PSCmdlet -ErrorAction Stop

    if ($PsCmdlet.ParameterSetName -eq 'ByUserId') {
        Write-Output ($Response | ConvertTo-TeamViewerUser -PropertiesToLoad $PropertiesToLoad)
    }
    else {
        Write-Output ($Response.users | ConvertTo-TeamViewerUser -PropertiesToLoad $PropertiesToLoad)
    }
}
