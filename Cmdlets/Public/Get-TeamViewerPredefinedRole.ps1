function Get-TeamViewerPredefinedRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.PredefinedRole')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    begin {
        $Parameters = @{}
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/predefined"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response | ConvertTo-TeamViewerPredefinedRole)
    }
}
