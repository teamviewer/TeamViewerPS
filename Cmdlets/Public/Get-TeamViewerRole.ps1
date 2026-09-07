function Get-TeamViewerRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Role')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    begin {
        $Parameters = @{ }
        $ResourceUri = "$(Get-TeamViewerAPIUri)/userroles"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.Roles | ConvertTo-TeamViewerRole)
    }
}
