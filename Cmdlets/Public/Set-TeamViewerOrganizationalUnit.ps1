function Set-TeamViewerOrganizationalUnit {
        [CmdletBinding(SupportsShouldProcess = $true)]

        param(
                [Parameter(Mandatory = $true)]
                [ValidateNotNullOrEmpty()]
                [Alias('Token')]
                [securestring]
                $ApiToken,

                [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
                [ValidateScript({ $_ | Resolve-TeamViewerOrganizationalUnitId })]
                [Alias('Id', 'OrganizationalUnitId')]
                [object]
                $OrganizationalUnit,

                [Parameter(Mandatory = $false)]
                [ValidateLength(1, 100)]
                [string]
                $Name,

                [Parameter(Mandatory = $false)]
                [ValidateLength(1, 300)]
                [string]
                $Description,

                [Parameter(Mandatory = $false)]
                [ValidateScript({ $_ -match '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$' })]
                [Alias('ParentId')]
                [string]
                $Parent
        )

        begin {
                $Body = @{ }

                # Append parameters to request body
                if ($Name) {
                        $Body.name = $Name
                }

                if ($Description) {
                        $Body.description = $Description
                }

                if ($Parent) {
                        $Body.parentId = $Parent
                }
        }

        process {
                $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
                $Uri = "$(Get-TeamViewerApiUri)/organizationalunits/$OrganizationalUnitId"

                if ($PSCmdlet.ShouldProcess($OrganizationalUnitId, 'Change organizational unit')) {
                        $response = Invoke-TeamViewerRestMethod `
                                -ApiToken $ApiToken `
                                -Uri $Uri `
                                -Method Put `
                                -ContentType 'application/json; charset=utf-8' `
                                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                                -WriteErrorTo $PSCmdlet `
                                -ErrorAction Stop

                        $response | ConvertTo-TeamViewerOrganizationalUnit
                }
        }
}
