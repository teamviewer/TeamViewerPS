function ConvertTo-TeamViewerUser {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $PropertiesToLoad = 'All'
    )

    process {
        $Properties = @{
            Id    = $InputObject.id
            Name  = $InputObject.name
            Email = $InputObject.email
        }

        if ($InputObject.userRoleId) {
            $Properties += @{
                RoleId = $InputObject.userRoleId
            }
        }

        if ($PropertiesToLoad -eq 'All') {
            $Properties += @{
                Active            = $InputObject.active
                LastAccessDate    = $InputObject.last_access_date | ConvertTo-DateTime
                TFAEnforcement    = $InputObject.tfa_enforcement
                TFAEnabled        = $InputObject.tfa_enabled
                LogSessions       = $InputObject.log_sessions
                ShowCommentWindow = $InputObject.show_comment_window
                SSOStatus         = $InputObject.sso_status

            }

            if ($InputObject.activated_license_id) {
                $Properties += @{
                    ActivatedLicenseId      = [guid]$InputObject.activated_license_id
                    ActivatedLicenseName    = $InputObject.activated_license_name
                    ActivatedSubLicenseName = $InputObject.activated_subLicense_name
                }
            }

            if ($InputObject.activated_meeting_license_key) {
                $Properties += @{
                    ActivatedMeetingLicenseId = [guid]$InputObject.activated_meeting_license_key
                }
            }

            if ($InputObject.online_state) {
                $Properties += @{
                    OnlineState = $InputObject.online_state
                }
            }

            if ($InputObject.custom_quicksupport_id) {
                $Properties += @{
                    CustomQuickSupportId = $InputObject.custom_quicksupport_id
                }
            }

            if ($InputObject.custom_quickjoin_id) {
                $Properties += @{
                    CustomQuickJoinId = $InputObject.custom_quickjoin_id
                }
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.Name) <$($this.Email)>"
        }

        Write-Output $Result
    }
}
