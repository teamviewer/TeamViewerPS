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
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/contacts/$contactId"

        if ($PSCmdlet.ShouldProcess($contactId, 'Remove contact')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
