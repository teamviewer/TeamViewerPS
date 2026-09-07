function Get-TeamViewerRolePermission {
    [CmdletBinding()]

    [OutputType([string[]])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $ResourceUri = "$(Get-TeamViewerAPIUri)/userroles/permissions"
    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $ResourceUri `
        -Method Get `
        -Body @{ } `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    if ($Response -is [System.Collections.IDictionary] -and $Response.Contains('Permissions')) {
        $PermissionList = $Response['Permissions']
    }
    elseif ($Response.PSObject.Properties['Permissions']) {
        $PermissionList = $Response.Permissions
    }
    else {
        $PermissionList = $Response
    }

    Write-Output ($PermissionList | Sort-Object)
}
