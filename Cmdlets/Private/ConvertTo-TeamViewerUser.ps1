function ConvertTo-TeamViewerUser {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $Properties = 'Minimal'
    )

    process {
        $Output_Properties = @{
            Id    = $InputObject.id
            Name  = $InputObject.name
            Email = $InputObject.email
        }

        if ($InputObject.userRoleId) {
            $Output_Properties += @{
                RoleId = $InputObject.userRoleId
            }
        }

        if ($Properties -eq 'All') {
            $Output_Properties += @{
                Active            = $InputObject.active
                LastAccess_Date   = $InputObject.last_access_date | ConvertTo-DateTime
                Log_Sessions      = $InputObject.log_sessions
                ShowCommentWindow = $InputObject.show_comment_window
                SSO_Status        = $InputObject.sso_status
                TFA_Enforcement   = $InputObject.tfa_enforcement
                TFA_Enabled       = $InputObject.tfa_enabled
            }

            if ($InputObject.activated_license_id) {
                $Output_Properties += @{
                    ActivatedLicenseId       = [guid]$InputObject.activated_license_id
                    ActivatedLicense_Name    = $InputObject.activated_license_name
                    ActivatedSubLicense_Name = $InputObject.activated_subLicense_name
                }
            }

            if ($InputObject.activated_meeting_license_key) {
                $Output_Properties += @{
                    ActivatedMeetingLicenseId = [guid]$InputObject.activated_meeting_license_key
                }
            }

            if ($InputObject.online_state) {
                $Output_Properties += @{
                    OnlineState = $InputObject.online_state
                }
            }

            if ($InputObject.custom_quicksupport_id) {
                $Output_Properties += @{
                    CustomQuickSupportId = $InputObject.custom_quicksupport_id
                }
            }

            if ($InputObject.custom_quickjoin_id) {
                $Output_Properties += @{
                    CustomQuickJoinId = $InputObject.custom_quickjoin_id
                }
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Output_Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

        Write-Output $Result
    }
}
