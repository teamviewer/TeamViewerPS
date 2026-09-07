function Remove-TeamViewerDefaultRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    begin {
        $Parameters = @{}
        $ResourceUri = "$(Get-TeamViewerAPIUri)/userroles/predefined"
    }

    process {
        if ($PSCmdlet.ShouldProcess('DefaultRole', 'Remove Default role')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method DELETE `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
