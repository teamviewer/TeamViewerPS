function Set-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Token')]
        [securestring]
        $ApiToken,

        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerOrganizationalUnitId })]
        [Alias('Id', 'OrganizationalUnitId')]
        [PSObject]
        $OrganizationalUnit,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [ValidateLength(1, 100)]
        [string]
        $Name,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [ValidateLength(1, 300)]
        [string]
        $Description,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [ValidateScript({ $_ -match '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$' })]
        [string]
        $ParentId
    )

    Begin {
        # Construct the API base URI
        $Uri = "$(Get-TeamViewerApiUri)/organizationalunits"

        # Append Organizational Unit Id to base URI
        $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $Uri += "/$OrganizationalUnitId"

        # Append parameters to request body
        if ($Name) {
            $Body.name = $Name
        }
        if ($Description) {
            $Body.description = $Description
        }
        if ($ParentId) {
            $Body.parentId = $ParentId
        }
    }

    Process {
        if ($PSCmdlet.ShouldProcess($OrganizationalUnit.ToString(), 'Change organizational unit')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($response | ConvertTo-TeamViewerOrganizationalUnit)
        }
    }
}
