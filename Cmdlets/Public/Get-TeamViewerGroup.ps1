function Get-TeamViewerGroup {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.Group')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByGroupId')]
        [Alias('Id', 'GroupId')]
        [string]
        $Group,

        [Parameter(ParameterSetName = 'List')]
        [Alias('PartialName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('OnlyShared', 'OnlyNotShared')]
        [string]
        $FilterBy_Shared
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/groups"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $Resource_Uri += "/$Group"
            $Parameters = $null
        }
        'List' {
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
        -APIToken $APIToken `
        -Uri $Resource_Uri `
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
