function Resolve-TeamViewerSsoDomainId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Domain
    )
    Process {
        if ($Domain.PSObject.TypeNames -contains 'TeamViewerPS.SsoDomain') {
            return [guid]$Domain.Id
        }
        elseif ($Domain -is [string]) {
            return [guid]$Domain
        }
        elseif ($Domain -is [guid]) {
            return $Domain
        }
        else {
            throw "Invalid SSO domain identifier '$Domain'. Must be either a [TeamViewerPS.SsoDomain], [guid] or [string]."
        }
    }
}
