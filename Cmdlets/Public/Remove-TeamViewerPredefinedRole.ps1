function Remove-TeamViewerPredefinedRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )


    begin {
        $parameters = @{}
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/predefined"
    }

    process {
        if ($PSCmdlet.ShouldProcess('PredefinedRole', 'Remove Predefined role')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method DELETE `
                -Body $parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
