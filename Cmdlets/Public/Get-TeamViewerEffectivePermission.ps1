function Get-TeamViewerEffectivePermission {
    [CmdletBinding(DefaultParameterSetName = '')]

    [OutputType([pscustomobject])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/users/effectivepermissions"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
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

