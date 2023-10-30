BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_FilePath = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets') -Filter '*.psm1' -File).FullName
    $Script:Module_Name = (Split-Path -Path $Module_FilePath -Leaf).Replace('.psm1', '')
    $Script:PublicFuncFiles = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Public') -Filter '*.ps1' -File | Select-Object BaseName)
    $Script:TestFilesDir = Join-Path -Path $Module_RootPath -ChildPath 'Tests\Public'
    $Script:HelpFilesDir = Join-Path -Path $Module_RootPath -ChildPath 'Docs\Help'
}

Describe 'Public Function File Checks' {
    Context 'Comparing directories' {
        It 'Function has a corresponding test file' {
            foreach ($funcName in $PublicFuncFiles.BaseName ) {
                $testFilePath = Join-Path -Path $TestFilesDir -ChildPath "$funcName.Tests.ps1"
                Test-Path $testFilePath | Should -Be $true
            }
        }
    }

    It 'Function has a corresponding help file' {
        foreach ($funcName in $PublicFuncFiles.BaseName) {
            $helpFilePath = Join-Path -Path $HelpFilesDir -ChildPath "$funcName.md"
            Test-Path $helpFilePath | Should -Be $true
        }
    }
}


