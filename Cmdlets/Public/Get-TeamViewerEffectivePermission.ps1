function Get-TeamViewerEffectivePermission {
    [CmdletBinding(DefaultParameterSetName = '')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/users/effectivepermissions"
    }

    process {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        if ($null -eq $response -or $response.Count -eq 0) {
            $response = @{}
        }
        return [PSCustomObject] $response
    }
}

