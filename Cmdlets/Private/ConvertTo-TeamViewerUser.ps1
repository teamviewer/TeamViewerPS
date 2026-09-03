function ConvertTo-TeamViewerUser {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $PropertiesToLoad = 'Minimal'
    )

    process {
        $Properties = @{
            Id    = $InputObject.id
            Name  = $InputObject.name
            Email = $InputObject.email
        }

        if ($InputObject.userRoleId) {
            $Properties += @{
                Role_Id = $InputObject.userRoleId
            }
        }

        if ($PropertiesToLoad -eq 'All') {
            $Properties += @{
                Active            = $InputObject.active
                LastAccess_Date   = $InputObject.last_access_date | ConvertTo-DateTime
                Log_Sessions      = $InputObject.log_sessions
                ShowCommentWindow = $InputObject.show_comment_window
                SSO_Status        = $InputObject.sso_status
                TFA_Enforcement   = $InputObject.tfa_enforcement
                TFA_Enabled       = $InputObject.tfa_enabled
            }

            if ($InputObject.activated_license_id) {
                $Properties += @{
                    ActivatedLicense_Id      = [guid]$InputObject.activated_license_id
                    ActivatedLicense_Name    = $InputObject.activated_license_name
                    ActivatedSubLicense_Name = $InputObject.activated_subLicense_name
                }
            }

            if ($InputObject.activated_meeting_license_key) {
                $Properties += @{
                    ActivatedMeetingLicense_Id = [guid]$InputObject.activated_meeting_license_key
                }
            }

            if ($InputObject.online_state) {
                $Properties += @{
                    OnlineState = $InputObject.online_state
                }
            }

            if ($InputObject.custom_quicksupport_id) {
                $Properties += @{
                    CustomQuickSupport_Id = $InputObject.custom_quicksupport_id
                }
            }

            if ($InputObject.custom_quickjoin_id) {
                $Properties += @{
                    CustomQuickJoin_Id = $InputObject.custom_quickjoin_id
                }
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

        Write-Output $Result
    }
}
