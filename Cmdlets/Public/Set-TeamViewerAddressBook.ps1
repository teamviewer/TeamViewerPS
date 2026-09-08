function Set-TeamViewerAddressBook {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByParameters')]
        [bool]
        $Enabled,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    $null = $Property
    $Body = @{}

    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($PSBoundParameters.ContainsKey('Enabled')) {
                $Body['addressBookAvailable'] = $Enabled
            }
        }
        'ByProperties' {
            @('addressBookAvailable') | Where-Object { $Property[$_] } | ForEach-Object { $Body[$_] = $Property[$_] }
        }
    }

    if ($Body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the address book settings.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/companyaddressbook"

    if ($PSCmdlet.ShouldProcess('Company Address Book')) {
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
