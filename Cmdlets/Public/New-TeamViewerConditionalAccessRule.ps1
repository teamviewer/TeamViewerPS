function New-TeamViewerConditionalAccessRule {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.ConditionalAccessRule')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [Alias('Source')]
        [string]
        $SourceId,

        [Parameter(Mandatory = $true)]
        [ConditionalAccessSourceTargetType]
        $SourceType,

        [Parameter(Mandatory = $true)]
        [Alias('Target')]
        [string]
        $TargetId,

        [Parameter(Mandatory = $true)]
        [ConditionalAccessSourceTargetType]
        $TargetType,

        [Alias('OptionSet')]
        [guid]
        $OptionSetId,

        [Alias('FeaturesOption')]
        [guid]
        $FeaturesOptionId,

        [Alias('TimeOption')]
        [guid]
        $TimeOptionId,

        [Alias('LocationOption')]
        [guid]
        $LocationOptionId,

        [Alias('ApprovalOption')]
        [guid]
        $ApprovalOptionId,

        [ValidateCount(0, 100)]
        [object[]]
        $Expiration,

        [ValidateLength(0, 200)]
        [string]
        $Comment,

        [string]
        $ModificationReason
    )

    $Body = @{
        sourceId   = $SourceId
        sourceType = [int]$SourceType
        targetId   = $TargetId
        targetType = [int]$TargetType
    }
    @('OptionSetId', 'FeaturesOptionId', 'TimeOptionId', 'LocationOptionId', 'ApprovalOptionId', 'Comment', 'ModificationReason') |
    Where-Object { $PSBoundParameters.ContainsKey($_) } |
    ForEach-Object { $Body[$_.Substring(0, 1).ToLowerInvariant() + $_.Substring(1)] = $PSBoundParameters[$_] }

    if ($PSBoundParameters.ContainsKey('Expiration')) {
        $Body['expirations'] = @($Expiration)
    }

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Rules"

    if ($PSCmdlet.ShouldProcess("$SourceId to $TargetId", 'Create conditional access rule')) {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 10))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response | ConvertTo-TeamViewerConditionalAccessRule)
    }
}
