function Get-TeamViewerRole {
    [CmdletBinding(DefaultParameterSetName = '')]

    [OutputType('System.Management.Automation.PSCustomObject', 'TeamViewerPS.Role')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [switch]
        [Alias('ListPermissions')]
        $Permissions
    )

    begin {
        $parameters = @{ }
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
        if ($Permissions) {
            $resourceUri += '/permissions'
        }
    }

    process {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($Permissions) {
            Write-Output [PSCustomObject] $response
        }
        else {
            Write-Output ($response.Roles | ConvertTo-TeamViewerRole)
        }
    }
}
