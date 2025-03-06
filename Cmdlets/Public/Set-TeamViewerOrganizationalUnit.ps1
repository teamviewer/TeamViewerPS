function Set-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerOrganizationalUnitId } )]
        [Alias('OrganizationalUnitId')]
        [Alias('Id')]
        [object]
        $OrganizationalUnit,

        [Parameter(Mandatory = $true)]
        [Alias('OrganizationalUnitName')]
        [string]
        $Name
    )

    Begin {
        $id = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $resourceUri = "$(Get-TeamViewerApiUri)/organizationalunits/$id"
        $body = @{ name = $Name }
    }

    Process {
        if ($PSCmdlet.ShouldProcess($OrganizationalUnit.ToString(), 'Change organizational unit')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($response | ConvertTo-TeamViewerOrganizationalUnit)
        }
    }
}
