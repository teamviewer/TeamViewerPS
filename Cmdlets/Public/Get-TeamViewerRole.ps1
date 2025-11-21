function Get-TeamViewerRole {
    [CmdletBinding(DefaultParameterSetName = '')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [switch]
        [Alias('ListPermissions')]
        $Permissions
    )

    Begin {
        $parameters = @{ }
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
        if ($Permissions) {
            $resourceUri += '/permissions'
        }
    }

    Process {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        if ($Permissions) {
            return [PSCustomObject] $response
        }
        else {
            Write-Output ($response.Roles | ConvertTo-TeamViewerRole )
        }
    }
}

