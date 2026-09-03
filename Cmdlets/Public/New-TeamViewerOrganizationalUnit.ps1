function New-TeamViewerOrganizationalUnit {
        [CmdletBinding(SupportsShouldProcess = $true)]

        param(
                [Parameter(Mandatory = $true)]
                [ValidateNotNullOrEmpty()]
                [Alias('Token')]
                [securestring]
                $ApiToken,

                [Parameter( Mandatory = $true)]
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
                $Uri = "$(Get-TeamViewerApiUri)/organizationalunits"

                # Append parameters to request body
                $Body = @{ name = $Name }

                if ($Description) {
                        $Body.description = $Description
                }
                if ($Parent) {
                        $Body.parentId = $Parent
                }
        }

        process {
                if ($PSCmdlet.ShouldProcess($Name, 'Create organizational unit')) {
                        $Response = Invoke-TeamViewerRestMethod `
                                -ApiToken $ApiToken `
                                -Uri $Uri `
                                -Method Post `
                                -ContentType 'application/json; charset=utf-8' `
                                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                                -WriteErrorTo $PSCmdlet `
                                -ErrorAction Stop

                        $Response | ConvertTo-TeamViewerOrganizationalUnit
                }
        }
}
