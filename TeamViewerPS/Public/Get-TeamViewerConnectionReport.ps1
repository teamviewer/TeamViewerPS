function Get-TeamViewerConnectionReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $false)]
        [string]
        $UserName,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("User")]
        [object]
        $UserId,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("Group")]
        [object]
        $GroupId,

        [Parameter(Mandatory = $false)]
        [string]
        $DeviceName,

        [Parameter(Mandatory = $false)]
        [int]
        $DeviceId,

        [Parameter(Mandatory = $false)]
        [switch]
        $WithSessionCode,

        [Parameter(Mandatory = $false)]
        [switch]
        $WithoutSessionCode,

        [Parameter(Mandatory = $false)]
        [string]
        $SessionCode,

        [Parameter(Mandatory = $false)]
        [TeamViewerConnectionReportSessionType]
        $SupportSessionType,

        [Parameter(Mandatory = $true, ParameterSetName = "AbsoluteDates")]
        [DateTime]
        $StartDate,

        [Parameter(Mandatory = $false, ParameterSetName = "AbsoluteDates")]
        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [DateTime]
        $EndDate = (Get-Date),

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 12)]
        [int]
        $Months,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 31)]
        [int]
        $Days,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 24)]
        [int]
        $Hours,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 60)]
        [int]
        $Minutes,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Limit
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/reports/connections";

    $parameters = @{}

    if ($PSCmdlet.ParameterSetName -Eq 'RelativeDates') {
        $StartDate = $EndDate.AddMonths(-1 * $Months).AddDays(-1 * $Days).AddHours(-1 * $Hours).AddMinutes(-1 * $Minutes)
    }
    if ($StartDate -And $EndDate -And $StartDate -lt $EndDate) {
        $parameters.from_date = $StartDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $parameters.to_date = $EndDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    if ($UserName) {
        $parameters.username = $UserName
    }

    if ($UserId) {
        $parameters.userid = $UserId | Resolve-TeamViewerUserId
    }

    if ($DeviceName) {
        $parameters.devicename = $DeviceName
    }

    if ($DeviceId) {
        $parameters.deviceid = $DeviceId
    }

    if ($GroupId) {
        $parameters.groupid = $GroupId | Resolve-TeamViewerGroupId
    }

    if ($WithSessionCode -And !$WithoutSessionCode) {
        $parameters.has_code = $true
    }
    elseif ($WithoutSessionCode -And !$WithSessionCode) {
        $parameters.has_code = $false
    }

    if ($SessionCode) {
        $parameters.session_code = $SessionCode
    }

    if ($SupportSessionType) {
        $parameters.support_session_type = [int]$SupportSessionType
    }

    $remaining = $Limit
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        $results = ($response.records | ConvertTo-TeamViewerConnectionReport)
        if ($Limit) {
            Write-Output ($results | Select-Object -First $remaining)
            $remaining = $remaining - @($results).Count
        }
        else {
            Write-Output $results
        }
        $parameters.offset_id = $response.next_offset
    } while ($parameters.offset_id -And (!$Limit -Or $remaining -gt 0))
}
