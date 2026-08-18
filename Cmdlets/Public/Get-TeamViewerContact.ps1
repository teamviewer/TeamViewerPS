function Get-TeamViewerContact {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.Contact')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByContactId')]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias('ContactId')]
        [string]
        $Id,

        [Parameter(ParameterSetName = 'FilteredList')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterOnlineState,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/contacts"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByContactId' {
            $ResourceUri += "/$Id"
            $Parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $Parameters['name'] = $Name
            }
            if ($FilterOnlineState) {
                $Parameters['online_state'] = $FilterOnlineState.ToLower()
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
