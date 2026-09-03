function Get-TeamViewerContact {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.Contact')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByContact')]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias('Id', 'ContactId')]
        [string]
        $Contact,

        [Parameter(ParameterSetName = 'FilteredList')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterBy_OnlineState,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/contacts"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByContact' {
            $ResourceUri += "/$Contact"
            $Parameters = $null
        }
        'FilteredList' {
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
        -ApiToken $ApiToken `
        -Uri $ResourceUri `
        -Method Get `
        -Body $Parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response.contacts | ConvertTo-TeamViewerContact)
}
