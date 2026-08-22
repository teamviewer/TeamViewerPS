function ConvertTo-TeamViewerAccount {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id                = $InputObject.userid
            Name              = $InputObject.name
            Email             = $InputObject.email
            Email_IsValidated = $InputObject.email_validated
            Email_Language    = $InputObject.email_language
            Company_Name      = $InputObject.company_name
        }

        if ($InputObject.email_language -and $InputObject.email_language -ne 'auto') {
            $Properties['Email_Language'] = [System.Globalization.CultureInfo]($InputObject.email_language)
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Account')

        Write-Output $Result
    }
}
