function  Resolve-AssignmentErrorCode {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $exitCode
    )
    Begin {
        $exitCodeMessages = @{
            0   = 'Operation successful'
            1   = 'Misspelled or used a wrong command'
            2   = 'Signature verification error'
            3   = 'TeamViewer is not installed'
            4   = 'The assignment configuration could not be verified against the TeamViewer Cloud.Try again later.'
            400 = 'Invalid assignment ID'
            401 = 'TeamViewer service not running'
            402 = 'Service Incompatible Version'
            403 = 'Check your internet connection'
            404 = 'Another assignment process running'
            405 = 'Timeout'
            406 = 'Failed due to unknown reasons'
            407 = 'Access denied. Ensure local administrator rights'
            408 = 'Denied by policy'
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
