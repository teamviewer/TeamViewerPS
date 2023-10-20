function Remove-TeamViewerPredefinedRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )


    Begin {
        $parameters = @{}
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/predefined"
    }

    Process {
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
