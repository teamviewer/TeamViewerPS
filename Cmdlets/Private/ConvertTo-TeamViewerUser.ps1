function ConvertTo-TeamViewerUser {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $PropertiesToLoad = 'All'
    )

    process {
        $properties = @{
            Id    = $InputObject.id
            Name  = $InputObject.name
            Email = $InputObject.email
        }
        if ($InputObject.userRoleId) {
            $properties += @{
                RoleId = $InputObject.userRoleId
            }
        }

        if ($PropertiesToLoad -Eq 'All') {
            $properties += @{
                Active            = $InputObject.active
                LastAccessDate    = $InputObject.last_access_date
                TFAEnforcement    = $InputObject.tfa_enforcement
                TFAEnabled        = $InputObject.tfa_enabled
                LogSessions       = $InputObject.log_sessions
                ShowCommentWindow = $InputObject.show_comment_window
                SSOStatus         = $InputObject.sso_status

            }

            if ($InputObject.activated_license_id) {
                $properties += @{
                    ActivatedLicenseId      = [guid]$InputObject.activated_license_id
                    ActivatedLicenseName    = $InputObject.activated_license_name
                    ActivatedSubLicenseName = $InputObject.activated_subLicense_name
                }
            }

            if ($InputObject.activated_meeting_license_key) {
                $properties += @{
                    ActivatedMeetingLicenseId = [guid]$InputObject.activated_meeting_license_key
                }
            }
            if ($InputObject.online_state) {
                $properties += @{
                    OnlineState = $InputObject.online_state
                }
            }
            if ($InputObject.custom_quicksupport_id) {
                $properties += @{
                    CustomQuickSupportId = $InputObject.custom_quicksupport_id
                }
            }
            if ($InputObject.custom_quickjoin_id) {
                $properties += @{
                    CustomQuickJoinId = $InputObject.custom_quickjoin_id
                }
            }
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            Write-Output "$($this.Name) <$($this.Email)>"
        }

        Write-Output $result
    }
}
