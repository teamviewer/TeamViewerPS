function Remove-TeamviewerPolicyFromManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('Id', 'GroupId', 'ManagedGroupId', 'ManagedGroup')]
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
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId/policy/remove"

        if ($PSCmdlet.ShouldProcess($Group.ToString(), 'Change managed group entry')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
