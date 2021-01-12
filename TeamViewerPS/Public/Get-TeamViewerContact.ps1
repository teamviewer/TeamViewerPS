function Get-TeamViewerContact {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByContactId")]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias("ContactId")]
        [string]
        $Id,

        [Parameter(ParameterSetName = "FilteredList")]
        [Alias("PartialName")]
        [string]
        $Name,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterOnlineState,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/contacts";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByContactId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $parameters['name'] = $Name
            }
            if ($FilterOnlineState) {
                $parameters['online_state'] = $FilterOnlineState.ToLower()
            }
            if ($Group) {
                $groupId = $Group | Resolve-TeamViewerGroupId
                $parameters['groupid'] = $groupId
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

    Write-Output ($response.contacts | ConvertTo-TeamViewerContact)
}
