function Remove-TeamViewerContact {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias('ContactId')]
        [Alias('Id')]
        [object]
        $Contact
    )

    process {
        $contactId = $Contact | Resolve-TeamViewerContactId
        $ResourceUri = "$(Get-TeamViewerApiUri)/contacts/$contactId"

        if ($PSCmdlet.ShouldProcess($contactId, 'Remove contact')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
