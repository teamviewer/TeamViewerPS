function Get-TeamViewerGroup {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByGroupId")]
        [Alias("GroupId")]
        [string]
        $Id,

        [Parameter(ParameterSetName = "FilteredList")]
        [Alias("PartialName")]
        [string]
        $Name,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateSet('OnlyShared', 'OnlyNotShared')]
        [string]
        $FilterShared
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/groups";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $parameters['name'] = $Name
            }
            switch ($FilterShared) {
                'OnlyShared' { $parameters['shared'] = $true }
                'OnlyNotShared' { $parameters['shared'] = $false }
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

    if ($PsCmdlet.ParameterSetName -Eq 'ByGroupId') {
        Write-Output ($response | ConvertTo-TeamViewerGroup)
    }
    else {
        Write-Output ($response.groups | ConvertTo-TeamViewerGroup)
    }
}
