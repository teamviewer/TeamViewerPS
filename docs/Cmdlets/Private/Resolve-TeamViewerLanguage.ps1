function Resolve-TeamViewerLanguage {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]
        $InputObject
    )
    Process {
        $supportedLanguages = @(
            'bg', 'cs', 'da', 'de', 'el', 'en', 'es', 'fi', 'fr', 'hr', 'hu', 'id', 'it', 'ja',
            'ko', 'lt', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sr', 'sv', 'th', 'tr', 'uk',
            'vi', 'zh_CN', 'zh_TW', 'auto')

        $language = $InputObject
        if ($InputObject -is [cultureinfo]) {
            $language = switch ($InputObject.Name) {
                'zh-CN' { 'zh_CN' }
                'zh-TW' { 'zh_TW' }
                default { $InputObject.TwoLetterISOLanguageName }
            }
        }

        if ($supportedLanguages -notcontains $language) {
            throw "Invalid culture '$language'. Supported languages are: $supportedLanguages"
        }

        return $language
    }
}
