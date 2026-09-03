function Remove-TeamviewerPolicyFromManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter(Mandatory = $true)]
        [PolicyType]
        $PolicyType
    )

    begin {
        $Body = @{
            'policy_type' = [int]$PolicyType
        }
    }

    process {
        $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/policy/remove"

        if ($PSCmdlet.ShouldProcess($Group.ToString(), 'Change managed group entry')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
