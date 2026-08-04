function Set-TeamViewerCompany {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    $null = $Property

    $body = @{}
    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $body['name'] = $Name
            }
        }
        'ByProperties' {
            @('name') | Where-Object { $Property[$_] } | ForEach-Object { $body[$_] = $Property[$_] }
        }
    }

    if ($body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the company.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/company"

    if ($PSCmdlet.ShouldProcess('TeamViewer company')) {
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