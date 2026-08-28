function Get-TeamViewerGroup {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.Group')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByGroup')]
        [Alias('Id', 'GroupId')]
        [string]
        $Group,

        [Parameter(ParameterSetName = 'FilteredList')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateSet('OnlyShared', 'OnlyNotShared')]
        [string]
        $FilterBy_Shared
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/groups"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroup' {
            $ResourceUri += "/$Group"
            $Parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $Parameters['name'] = $Name
            }
            switch ($FilterBy_Shared) {
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

    if ($PsCmdlet.ParameterSetName -eq 'ByGroup') {
        Write-Output ($Response | ConvertTo-TeamViewerGroup)
    }
    else {
        Write-Output ($Response.groups | ConvertTo-TeamViewerGroup)
    }
}
