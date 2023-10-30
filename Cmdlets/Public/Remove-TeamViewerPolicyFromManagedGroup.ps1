function Remove-TeamviewerPolicyFromManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
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
    Begin {
        $body = @{
            'policy_type' = [int]$PolicyType
        }
    }
    Process {
        $groupId = $Group | Resolve-TeamViewerManagedGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/policy/remove"

        if ($PSCmdlet.ShouldProcess($Group.ToString(), 'Change managed group entry')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
