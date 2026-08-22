function Set-TeamViewerAccount {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('DisplayName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $Password,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $OldPassword,

        [Parameter(ParameterSetName = 'ByParameters')]
        [ValidateScript( { $_ | Resolve-TeamViewerLanguage } )]
        [object]
        $EmailLanguage,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    # Warning suppresion doesn't seem to work.
    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $null = $Property

    $Body = @{}

    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $Body['name'] = $Name
            }

            if ($Email) {
                $Body['email'] = $Email
            }

            if ($Password) {
                if (-not $OldPassword) {
                    $PSCmdlet.ThrowTerminatingError(
                        ('Old password required when attempting to change account password.' | `
                            ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }

                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                $Body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null

                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($OldPassword)
                $Body['oldpassword'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }

            if ($EmailLanguage) {
                $Body['email_language'] = $EmailLanguage | Resolve-TeamViewerLanguage
            }
        }
        'ByProperties' {
            @('name', 'email', 'password', 'oldpassword', 'email_language') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $Body[$_] = $Property[$_] }
        }
    }

    if ($Body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the account.' | `
                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $ResourceUri = "$(Get-TeamViewerApiUri)/account"

    if ($PSCmdlet.ShouldProcess('TeamViewer account')) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Put `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
