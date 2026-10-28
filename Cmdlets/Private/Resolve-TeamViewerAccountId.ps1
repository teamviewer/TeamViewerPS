function Resolve-TeamViewerAccountId {
    [CmdletBinding()]

    [OutputType([uint32])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]
        $User,

        [System.Collections.IDictionary]
        $EmailCache = @{}
    )

    process {
        $Email = $null

        $Identifier = if ($User.PSObject.TypeNames -contains 'TeamViewerPS.User') {
            $User.Id
        }
        else {
            $User
        }

        if ($Identifier -is [string] -and $Identifier.Contains('@')) {
            $Email = $Identifier

            if ($EmailCache.Contains($Email)) {
                $Identifier = $EmailCache[$Email]
            }
            else {
                $MatchingUsers = @(Get-TeamViewerUser -APIToken $APIToken -Email $Email -ErrorAction Stop |
                    Where-Object -FilterScript { $_.Email -ieq $Email })
                if ($MatchingUsers.Count -eq 0) {
                    throw "No TeamViewer user found with email address '$Email'."
                }
                if ($MatchingUsers.Count -gt 1) {
                    throw "Multiple TeamViewer users found with email address '$Email'."
                }
                $Identifier = $MatchingUsers[0].Id
            }
        }

        $IdentifierText = [string]$Identifier
        $AccountId = [uint32]0

        if ($IdentifierText -cnotmatch '^u?[0-9]+$' -or
            -not [uint32]::TryParse(($IdentifierText -creplace '^u', ''), [ref]$AccountId)) {

            throw "Invalid account identifier '$Identifier'. Expected an unsigned 32-bit account ID, optionally prefixed with 'u'."
        }

        if ($Email) {
            $EmailCache[$Email] = $AccountId
        }

        Write-Output $AccountId
    }
}
