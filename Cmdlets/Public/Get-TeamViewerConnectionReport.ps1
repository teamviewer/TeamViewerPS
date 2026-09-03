function Get-TeamViewerConnectionReport {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.ConnectionReport')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $false)]
        [string]
        $UserName,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('UserId')]
        [object]
        $User,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter(Mandatory = $false)]
        [string]
        $DeviceName,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [int]
        $Device,

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

        [Parameter(Mandatory = $true, ParameterSetName = 'AbsoluteDates')]
        [DateTime]
        $StartDate,

        [Parameter(Mandatory = $false, ParameterSetName = 'AbsoluteDates')]
        [Parameter(Mandatory = $false, ParameterSetName = 'RelativeDates')]
        [DateTime]
        $EndDate = (Get-Date),

        [Parameter(Mandatory = $false, ParameterSetName = 'RelativeDates')]
        [ValidateRange(0, 12)]
        [int]
        $Months,

        [Parameter(Mandatory = $false, ParameterSetName = 'RelativeDates')]
        [ValidateRange(0, 31)]
        [int]
        $Days,

        [Parameter(Mandatory = $false, ParameterSetName = 'RelativeDates')]
        [ValidateRange(0, 24)]
        [int]
        $Hours,

        [Parameter(Mandatory = $false, ParameterSetName = 'RelativeDates')]
        [ValidateRange(0, 60)]
        [int]
        $Minutes,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Limit
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/reports/connections"

    $Parameters = @{}

    if ($PSCmdlet.ParameterSetName -eq 'RelativeDates') {
        $StartDate = $EndDate.AddMonths(-1 * $Months).AddDays(-1 * $Days).AddHours(-1 * $Hours).AddMinutes(-1 * $Minutes)
    }

    if ($StartDate -and $EndDate -and $StartDate -lt $EndDate) {
        $Parameters.from_date = $StartDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        $Parameters.to_date = $EndDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    }

    if ($UserName) {
        $Parameters.username = $UserName
    }

    if ($User) {
        $Parameters.userid = $User | Resolve-TeamViewerUserId
    }

    if ($DeviceName) {
        $Parameters.devicename = $DeviceName
    }

    if ($Device) {
        $Parameters.deviceid = $Device
    }

    if ($Group) {
        $Parameters.groupid = $Group | Resolve-TeamViewerGroupId
    }

    if ($WithSessionCode -and !$WithoutSessionCode) {
        $Parameters.has_code = $true
    }
    elseif ($WithoutSessionCode -and !$WithSessionCode) {
        $Parameters.has_code = $false
    }

    if ($SessionCode) {
        $Parameters.session_code = $SessionCode
    }

    if ($SupportSessionType) {
        $Parameters.support_session_type = [int]$SupportSessionType
    }

    $Remaining = $Limit

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        $Results = ($Response.records | ConvertTo-TeamViewerConnectionReport)

        if ($Limit) {
            Write-Output ($Results | Select-Object -First $Remaining)
            $Remaining = $Remaining - @($Results).Count
        }
        else {
            Write-Output $Results
        }
        $Parameters.offset_id = $Response.next_offset
    } while ($Parameters.offset_id -and (!$Limit -or $Remaining -gt 0))
}
