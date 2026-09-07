function Get-TeamViewerDefaultRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.DefaultRole')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    begin {
        $Parameters = @{}
        $ResourceUri = "$(Get-TeamViewerAPIUri)/userroles/predefined"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response | ConvertTo-TeamViewerDefaultRole)
    }
}
