function Remove-TeamViewerPredefinedRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    begin {
        $Parameters = @{}
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/predefined"
    }

    process {
        if ($PSCmdlet.ShouldProcess('PredefinedRole', 'Remove Predefined role')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method DELETE `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
