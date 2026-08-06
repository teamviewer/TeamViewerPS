function Resolve-TeamViewerSsoDomainId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Domain
    )

    process {
        if ($Domain.PSObject.TypeNames -contains 'TeamViewerPS.SsoDomain') {
            [guid]$Domain.Id
        }
        elseif ($Domain -is [string]) {
            [guid]$Domain
        }
        elseif ($Domain -is [guid]) {
            $Domain
        }
        else {
            throw "Invalid SSO domain identifier '$Domain'. Must be either a [TeamViewerPS.SsoDomain], [guid] or [string]."
        }
    }
}
