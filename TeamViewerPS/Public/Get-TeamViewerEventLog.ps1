function Get-TeamViewerEventLog {
    [CmdletBinding(DefaultParameterSetName = "RelativeDates")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

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
                    "CompanyAddressBook",
                    "CompanyAdministration",
                    "ConditionalAccess",
                    "CustomModules",
                    "GroupManagement",
                    "LicenseManagement",
                    "Policy",
                    "Session",
                    "UserGroups",
                    "UserProfile"
                ) | Where-Object { $_ -like "$wordToComplete*" }
            })]
        [string[]]
        $EventTypes,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserEmail } )]
        [Alias("Users")]
        [object[]]
        $AccountEmails,

        [Parameter(Mandatory = $false)]
        [string]
        $AffectedItem,

        [Parameter(Mandatory = $false)]
        [Alias("RemoteControlSession")]
        [guid]
        $RemoteControlSessionId
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/EventLogging";

    $Limit = if ($Limit -lt 0) { $null } else { $Limit }

    if ($PSCmdlet.ParameterSetName -Eq 'RelativeDates') {
        $Hours = if (!$Months -And !$Days -And !$Hours -And !$Minutes) { 1 } else { $Hours }
        $StartDate = $EndDate.AddMonths(-1 * $Months).AddDays(-1 * $Days).AddHours(-1 * $Hours).AddMinutes(-1 * $Minutes)
    }

    $parameters = @{
        StartDate = $StartDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        EndDate   = $EndDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    if ($EventNames) {
        $parameters.EventNames = $EventNames
    }
    if ($EventTypes) {
        $parameters.EventTypes = $EventTypes
    }
    if ($AccountEmails) {
        $parameters.AccountEmails = @($AccountEmails | Resolve-TeamViewerUserEmail)
    }
    if ($AffectedItem) {
        $parameters.AffectedItem = $AffectedItem
    }
    if ($RemoteControlSessionId) {
        $parameters.RCSessionGuid = $RemoteControlSessionId
    }

    $remaining = $Limit
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($parameters | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        $results = ($response.AuditEvents | ConvertTo-TeamViewerAuditEvent)
        if ($Limit) {
            Write-Output ($results | Select-Object -First $remaining)
            $remaining = $remaining - @($results).Count
        }
        else {
            Write-Output $results
        }
        $parameters.ContinuationToken = $response.ContinuationToken
    } while ($parameters.ContinuationToken -And (!$Limit -Or $remaining -gt 0))
}
