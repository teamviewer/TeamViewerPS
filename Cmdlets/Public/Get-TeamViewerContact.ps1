function Get-TeamViewerContact {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.Contact')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByContactId')]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias('Id', 'ContactId')]
        [string]
        $Contact,

        [Parameter(ParameterSetName = 'List')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterBy_OnlineState,

        [Parameter(ParameterSetName = 'List')]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/contacts"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByContactId' {
            $Resource_Uri += "/$Contact"
            $Parameters = $null
        }
        'List' {
            if ($Name) {
                $Parameters['name'] = $Name
            }
            if ($FilterBy_OnlineState) {
                $Parameters['online_state'] = $FilterBy_OnlineState.ToLower()
            }
            if ($Group) {
                $GroupId = $Group | Resolve-TeamViewerGroupId
                $Parameters['groupid'] = $GroupId
            }
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -Body $Parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response.contacts | ConvertTo-TeamViewerContact)
}
