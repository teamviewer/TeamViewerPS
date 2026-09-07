function Get-TeamViewerUser {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.User')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByUserId')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('Id', 'UserId')]
        [string]
        $User,

        [Parameter(ParameterSetName = 'List')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'List')]
        [Alias('EmailAddress')]
        [string[]]
        $Email,

        [Parameter(ParameterSetName = 'List')]
        [string[]]
        $Permissions,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $Properties = 'Minimal'
    )

    $Parameters = @{ }
    switch ($Properties) {
        'All' {
            $Parameters.full_list = $true
        }
        'Minimal' {
        }
    }

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/users"

    switch ($PsCmdlet.ParameterSetName) {
        'ByUserId' {
            $Resource_Uri += "/$User"
            $Parameters = $null
        }
        'List' {
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
        -APIToken $APIToken -Uri $Resource_Uri -Method Get -Body $Parameters -WriteErrorTo $PSCmdlet -ErrorAction Stop

    if ($PsCmdlet.ParameterSetName -eq 'ByUserId') {
        Write-Output ($Response | ConvertTo-TeamViewerUser -Properties $Properties)
    }
    else {
        Write-Output ($Response.users | ConvertTo-TeamViewerUser -Properties $Properties)
    }
}
