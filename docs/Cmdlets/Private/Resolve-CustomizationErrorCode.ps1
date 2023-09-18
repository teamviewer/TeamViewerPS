function  Resolve-CustomizationErrorCode {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $exitCode
    )
    Begin {
        $exitCodeMessages = @{
            0   = 'Operation successful'
            1   = 'Invalid command line arguments'
            500 = 'An internal error occurred. See TeamViewer log files for more details!'
            501 = 'The current user was denied access'
            502 = 'The download of the custom configuration timed out'
            503 = 'Invalid Module'
            504 = 'Restart of the GUI failed'
            505 = 'Custom configuration failed. See the TeamViewer log files for more details and check if the custom configuration id is still valid.'
            506 = 'Removal of custom configuration failed. See the TeamViewer log files for more details!'
        }
    }
    Process {
        if ($exitCode) {
            if ($exitCodeMessages.ContainsKey($exitCode)) {
                Write-Output $exitCodeMessages[$exitCode]
            }
            else {
                Write-Output "Unexpected error code: $exitCode. Check TeamViewer documentation!"
            }
        }
        elseif ($exitCode -eq 0) {
            Write-Output $exitCodeMessages[$exitCode]
        }
    }
}
