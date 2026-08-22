function Get-TeamViewerGroup {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.Group')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByGroupId')]
        [Alias('GroupId')]
        [string]
        $Id,

        [Parameter(ParameterSetName = 'FilteredList')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateSet('OnlyShared', 'OnlyNotShared')]
        [string]
        $FilterShared
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/groups"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $ResourceUri += "/$Id"
            $Parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $Parameters['name'] = $Name
            }
            switch ($FilterShared) {
                'OnlyShared' {
                    $Parameters['shared'] = $true
                }
                'OnlyNotShared' {
                    $Parameters['shared'] = $false
                }
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

    if ($PsCmdlet.ParameterSetName -eq 'ByGroupId') {
        Write-Output ($Response | ConvertTo-TeamViewerGroup)
    }
    else {
        Write-Output ($Response.groups | ConvertTo-TeamViewerGroup)
    }
}
