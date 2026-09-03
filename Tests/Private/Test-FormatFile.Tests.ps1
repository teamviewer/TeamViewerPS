BeforeDiscovery {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_CmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets'
    $Script:FormatFilePath = Join-Path -Path $Module_CmdletsPath -ChildPath 'TeamViewerPS.format.ps1xml'
    $Script:PublicGetterFiles = @(Get-ChildItem -Path (Join-Path -Path $Module_CmdletsPath -ChildPath 'Public\Get-*.ps1') -File)

    $FormatDocument = [xml](Get-Content -Path $FormatFilePath -Raw)
    $Script:ListTypeNames = @($FormatDocument.Configuration.ViewDefinitions.View |
        Where-Object Name -Like '*-ListView' |
        Select-Object -ExpandProperty ViewSelectedBy |
        Select-Object -ExpandProperty TypeName)
    $Script:TableTypeNames = @($FormatDocument.Configuration.ViewDefinitions.View |
        Where-Object Name -Like '*-TableView' |
        Select-Object -ExpandProperty ViewSelectedBy |
        Select-Object -ExpandProperty TypeName)

    $GetterTypeNames = foreach ($PublicGetterFile in $PublicGetterFiles) {
        $Tokens = $null
        $ParseErrors = $null
        $Ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $PublicGetterFile.FullName,
            [ref]$Tokens,
            [ref]$ParseErrors
        )

        $Ast.FindAll({
                param($Node)

                $Node -is [System.Management.Automation.Language.AttributeAst] -and
                $Node.TypeName.Name -eq 'OutputType'
            }, $true) | ForEach-Object {
            $_.PositionalArguments | Where-Object {
                $_ -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
                $_.Value -like 'TeamViewerPS.*'
            } | Select-Object -ExpandProperty Value
        }
    }

    $Script:GetterTypeNames = @($GetterTypeNames | Sort-Object -Unique)
}

Describe 'Test-FormatFile' {
    It 'Includes every typed public getter in the list view' {
        $MissingTypeNames = @($GetterTypeNames | Where-Object { $_ -notin $ListTypeNames })

        $MissingTypeNames | Should -BeNullOrEmpty -Because 'Every typed public getter must have a list view'
    }

    It 'Includes every typed public getter in a table view' {
        $MissingTypeNames = @($GetterTypeNames | Where-Object { $_ -notin $TableTypeNames })

        $MissingTypeNames | Should -BeNullOrEmpty -Because 'Every typed public getter must have a table view'
    }

    It 'Does not include types without a typed public getter' {
        $UnexpectedTypeNames = @($ListTypeNames | Where-Object { $_ -notin $GetterTypeNames })

        $UnexpectedTypeNames | Should -BeNullOrEmpty -Because 'Format views must be derived from typed public getters'
    }

    It 'Uses the same fields in list and table views' {
        $ListViews = @($FormatDocument.Configuration.ViewDefinitions.View | Where-Object Name -Like '*-ListView')

        foreach ($ListView in $ListViews) {
            $TypeName = $ListView.ViewSelectedBy.TypeName
            $TableView = $FormatDocument.Configuration.ViewDefinitions.View |
            Where-Object Name -EQ ($ListView.Name -replace '-ListView$', '-TableView')

            $ListFields = @($ListView.ListControl.ListEntries.ListEntry.ListItems.ListItem.PropertyName)
            $TableFields = @($TableView.TableControl.TableRowEntries.TableRowEntry.TableColumnItems.TableColumnItem.PropertyName)

            $ListFields | Should -Be $TableFields -Because "$TypeName list and table views must expose the same fields"
        }
    }
}
