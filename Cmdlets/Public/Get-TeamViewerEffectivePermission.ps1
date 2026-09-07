function Get-TeamViewerEffectivePermission {
    [CmdletBinding(DefaultParameterSetName = '')]

    [OutputType([pscustomobject])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerAPIUri)/users/effectivepermissions"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        if ($null -eq $Response -or $Response.Count -eq 0) {
            $Response = @{}
        }

        Write-Output ([PSCustomObject] $Response)
    }
}

