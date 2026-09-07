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
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/predefined"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response | ConvertTo-TeamViewerDefaultRole)
    }
}
