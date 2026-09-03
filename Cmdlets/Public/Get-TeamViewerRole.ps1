function Get-TeamViewerRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Role')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    begin {
        $Parameters = @{ }
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.Roles | ConvertTo-TeamViewerRole)
    }
}
