function ConvertTo-TeamViewerAccount {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Name             = $InputObject.name
            Email            = $InputObject.email
            UserId           = $InputObject.userid
            CompanyName      = $InputObject.company_name
            IsEmailValidated = $InputObject.email_validated
            EmailLanguage    = $InputObject.email_language
        }
        if ($InputObject.email_language -And $InputObject.email_language -Ne 'auto') {
            $properties["EmailLanguage"] = [System.Globalization.CultureInfo]($InputObject.email_language)
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Account')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name) <$($this.Email)>"
        }
        Write-Output $result
    }
}
