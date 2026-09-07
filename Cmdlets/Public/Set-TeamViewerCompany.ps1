function Set-TeamViewerCompany {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    $null = $Property

    $Body = @{}

    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $Body['name'] = $Name
            }
        }
        'ByProperties' {
            @('name') | Where-Object { $Property[$_] } | ForEach-Object { $Body[$_] = $Property[$_] }
        }
    }

    if ($Body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the company.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/company"

    if ($PSCmdlet.ShouldProcess('TeamViewer company')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Put `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
