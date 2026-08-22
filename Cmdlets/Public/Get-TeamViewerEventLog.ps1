function Get-TeamViewerEventLog {
    [CmdletBinding(DefaultParameterSetName = 'RelativeDates')]

    [OutputType('TeamViewerPS.AuditEvent')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

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
        [ValidateRange(0, [int]::MaxValue)]
        [int]
        $Limit,

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter( {
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                $null = @($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                @(
                    'AddRemoteWorkerDevice',
                    'ChangedDisabledRemoteInput',
                    'ChangedShowBlackScreen',
                    'CompanyAddressBookDisabled',
                    'CompanyAddressBookEnabled',
                    'CompanyAddressBookMembersHid',
                    'CompanyAddressBookMembersUnhid'
                    'ConditionalAccessBlockMeetingStateChanged',
                    'ConditionalAccessDirectoryGroupAdded',
                    'ConditionalAccessDirectoryGroupDeleted',
                    'ConditionalAccessDirectoryGroupMembersAdded',
                    'ConditionalAccessDirectoryGroupMembersDeleted',
                    'ConditionalAccessRuleAdded',
                    'ConditionalAccessRuleDeleted',
                    'ConditionalAccessRuleModified',
                    'ConditionalAccessRuleVerificationStateChanged',
                    'CreateCustomHost',
                    'DeleteCustomHost',
                    'EditOwnProfile',
                    'EditTFAUsage',
                    'EditUserPermissions',
                    'EditUserProperties',
                    'EmailConfirmed',
                    'EndedRecording',
                    'EndedSession',
                    'GroupAdded',
                    'GroupDeleted',
                    'GroupShared',
                    'GroupUpdated',
                    'IncomingSession',
                    'JoinCompany',
                    'JoinedSession',
                    'LeftSession',
                    'ParticipantJoinedSession',
                    'ParticipantLeftSession',
                    'PausedRecording',
                    'PolicyAdded',
                    'PolicyDeleted',
                    'PolicyUpdated',
                    'ReceivedDisabledLocalInput',
                    'ReceivedFile',
                    'ReceivedShowBlackScreen',
                    'RemoveRemoteWorkerDevice',
                    'ResumedRecording',
                    'ScriptTokenAdded',
                    'ScriptTokenDeleted',
                    'ScriptTokenUpdated',
                    'SentFile',
                    'StartedRecording',
                    'StartedSession',
                    'SwitchedSides',
                    'UpdateCustomHost',
                    'UserCreated',
                    'UserDeleted',
                    'UserGroupCreated',
                    'UserGroupDeleted',
                    'UserGroupMembersAdded',
                    'UserGroupMembersRemoved',
                    'UserGroupUpdated',
                    'UserRemovedFromCompany'
                ) | Where-Object { $_ -like "$wordToComplete*" }
            } )]
        [string[]]
        $EventNames,

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter( {
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                $null = @($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                @(
                    'CompanyAddressBook',
                    'CompanyAdministration',
                    'ConditionalAccess',
                    'CustomModules',
                    'GroupManagement',
                    'LicenseManagement',
                    'Policy',
                    'Session',
                    'UserGroups',
                    'UserProfile'
                ) | Where-Object { $_ -like "$wordToComplete*" }
            })]
        [string[]]
        $EventTypes,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserEmail } )]
        [Alias('Users')]
        [object[]]
        $AccountEmails,

        [Parameter(Mandatory = $false)]
        [string]
        $AffectedItem,

        [Parameter(Mandatory = $false)]
        [Alias('RemoteControlSession')]
        [guid]
        $RemoteControlSessionId
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/EventLogging"

    $Limit = if ($Limit -lt 0) {
        $null
    }
    else {
        $Limit
    }

    if ($PSCmdlet.ParameterSetName -eq 'RelativeDates') {
        $Hours = if (!$Months -and !$Days -and !$Hours -and !$Minutes) {
            1
        }
        else {
            $Hours
        }
        $StartDate = $EndDate.AddMonths(-1 * $Months).AddDays(-1 * $Days).AddHours(-1 * $Hours).AddMinutes(-1 * $Minutes)
    }

    $Parameters = @{
        StartDate = $StartDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        EndDate   = $EndDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    }

    if ($EventNames) {
        $Parameters.EventNames = $EventNames
    }

    if ($EventTypes) {
        $Parameters.EventTypes = $EventTypes
    }

    if ($AccountEmails) {
        $Parameters.AccountEmails = @($AccountEmails | Resolve-TeamViewerUserEmail)
    }

    if ($AffectedItem) {
        $Parameters.AffectedItem = $AffectedItem
    }

    if ($RemoteControlSessionId) {
        $Parameters.RCSessionGuid = $RemoteControlSessionId
    }

    $Remaining = $Limit

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Parameters | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        $Results = ($Response.AuditEvents | ConvertTo-TeamViewerAuditEvent)

        if ($Limit) {
            Write-Output ($Results | Select-Object -First $Remaining)
            $Remaining = $Remaining - @($Results).Count
        }
        else {
            Write-Output $Results
        }
        $Parameters.ContinuationToken = $Response.ContinuationToken
    } while ($Parameters.ContinuationToken -and (!$Limit -or $Remaining -gt 0))
}
