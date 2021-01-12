function Set-TeamViewerAccount {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
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

    $body = @{}
    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $body['name'] = $Name
            }
            if ($Email) {
                $body['email'] = $Email
            }
            if ($Password) {
                if (-Not $OldPassword) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Old password required when attempting to change account password." | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }

                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null

                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($OldPassword)
                $body['oldpassword'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }
            if ($EmailLanguage) {
                $body['email_language'] = $EmailLanguage | Resolve-TeamViewerLanguage
            }
        }
        'ByProperties' {
            @('name', 'email', 'password', 'oldpassword', 'email_language') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $body[$_] = $Property[$_] }
        }
    }

    if ($body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ("The given input does not change the account." | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/account"

    if ($PSCmdlet.ShouldProcess("TeamViewer account")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Put `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
