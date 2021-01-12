function Invoke-ExternalCommand {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Command,

        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]
        $CommandArgs
    )
    & $Command @CommandArgs
}
