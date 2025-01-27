function Set-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerOrganizationalUnitId } )]
        [Alias('OrganizationalUnitId')]
        [Alias('Id')]
        [object]
        $OrganizationalUnit,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Description,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Parent,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    Begin {
        # Warning suppresion doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $body = @{}

        switch ($PSCmdlet.ParameterSetName) {
            'ByParameters' {
                $body['name'] = $Name

                if ($Description) {
                    $body['description'] = $Description
                }

                if ($Parent) {
                    $body['ParentId'] = $Parent
                }
            }
            'ByProperties' {
                @('name', 'description', 'parentid') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $body[$_] = $Property[$_] }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the organizational unit.' | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }

    Process {
        $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $resourceUri = "$(Get-TeamViewerApiUri)/organizationalunits/$OrganizationalUnitId"

        if ($PSCmdlet.ShouldProcess($groupId, 'Update organizational unit')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
