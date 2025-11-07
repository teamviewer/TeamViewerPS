function Get-TeamViewerEffectivePermission {
    [CmdletBinding(DefaultParameterSetName = '')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/users/effectivepermissions"
    }

    Process {
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

