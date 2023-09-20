function ConvertTo-ErrorRecord {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
    )
    Process {
        $category = $ErrorCategory
        $message = $InputObject.ToString()
        $errorId = 'TeamViewerError'

        if ($InputObject.PSObject.TypeNames -contains 'TeamViewerPS.RestError') {
            $category = switch ($InputObject.ErrorCategory) {
                'invalid_request' { [System.Management.Automation.ErrorCategory]::InvalidArgument }
                'invalid_token' { [System.Management.Automation.ErrorCategory]::AuthenticationError }
                'internal_error' { [System.Management.Automation.ErrorCategory]::NotSpecified }
                'rate_limit_reached' { [System.Management.Automation.ErrorCategory]::LimitsExceeded }
                'token_expired' { [System.Management.Automation.ErrorCategory]::AuthenticationError }
                'wrong_credentials' { [System.Management.Automation.ErrorCategory]::AuthenticationError }
                'invalid_client' { [System.Management.Automation.ErrorCategory]::InvalidArgument }
                'not_found' { [System.Management.Automation.ErrorCategory]::ObjectNotFound }
                'too_many_retries' { [System.Management.Automation.ErrorCategory]::LimitsExceeded }
                'invalid_permission' { [System.Management.Automation.ErrorCategory]::PermissionDenied }
                default { [System.Management.Automation.ErrorCategory]::NotSpecified }
            }
            $errorId = 'TeamViewerRestError'
        }

        $exception = [System.Management.Automation.RuntimeException]($message)
        $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $category, $null
        $errorRecord.ErrorDetails = $message
        return $errorRecord
    }
}
