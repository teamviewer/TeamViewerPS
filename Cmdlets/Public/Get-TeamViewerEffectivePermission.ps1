function Get-TeamViewerEffectivePermission {
    [CmdletBinding()]

    [OutputType([pscustomobject])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/users/effectivepermissions"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        if ($null -eq $Response -or $Response.Count -eq 0) {
            $Response = @{}
        }

        Write-Output ([PSCustomObject] $Response)
    }
}

