function Remove-TeamViewerContact {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias('ContactId')]
        [Alias('Id')]
        [object]
        $Contact
    )

    process {
        $contactId = $Contact | Resolve-TeamViewerContactId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/contacts/$contactId"

        if ($PSCmdlet.ShouldProcess($contactId, 'Remove contact')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
