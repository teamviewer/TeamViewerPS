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
        $Parameters = @{ }
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles"
        if ($Permissions) {
            $ResourceUri += '/permissions'
        }
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($Permissions) {
            Write-Output [PSCustomObject] $Response
        }
        else {
            Write-Output ($Response.Roles | ConvertTo-TeamViewerRole)
        }
    }
}
