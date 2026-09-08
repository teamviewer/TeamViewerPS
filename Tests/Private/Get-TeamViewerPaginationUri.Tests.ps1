BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\Get-TeamViewerPaginationUri.ps1"
}

Describe 'Get-TeamViewerPaginationUri' {
    It 'Appends a token to a URI with an existing query' {
        Get-TeamViewerPaginationUri -Uri 'https://unit.test/items?kind=device' -ParameterName 'continuationToken' -Token 'page 2' |
            Should -Be 'https://unit.test/items?kind=device&continuationToken=page%202'
    }

    It 'Adds a query to a URI without an existing query' {
        Get-TeamViewerPaginationUri -Uri 'https://unit.test/items' -ParameterName 'continuationToken' -Token 'page2' |
            Should -Be 'https://unit.test/items?continuationToken=page2'
    }
}
