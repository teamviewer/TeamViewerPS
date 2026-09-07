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
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.Roles | ConvertTo-TeamViewerRole)
    }
}
