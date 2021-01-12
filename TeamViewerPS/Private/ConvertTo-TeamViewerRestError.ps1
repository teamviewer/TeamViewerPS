function ConvertTo-TeamViewerRestError {
    param(
        [parameter(ValueFromPipeline)]
        $InputError
    )
    Process {
        try {
            $errorObject = ($InputError | Out-String | ConvertFrom-Json)
            $result = [PSCustomObject]@{
                Message        = $errorObject.error_description
                ErrorCategory  = $errorObject.error
                ErrorCode      = $errorObject.error_code
                ErrorSignature = $errorObject.error_signature
            }
            $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
                Write-Output "$($this.Message) ($($this.ErrorCategory))"
            }
            $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RestError')
            return $result
        }
        catch {
            return $InputError
        }
    }
}
