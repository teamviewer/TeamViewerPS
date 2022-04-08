---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Get-TeamViewerConnectionReport

## SYNOPSIS

Returns the TeamViewer session reports of the company associated with the given
API token.

## SYNTAX

### AbsoluteDates

```powershell
Get-TeamViewerConnectionReport -ApiToken <SecureString> [-UserName <String>] [-UserId <Object>]
 [-GroupId <Object>] [-DeviceName <String>] [-DeviceId <Int32>] [-WithSessionCode] [-WithoutSessionCode]
 [-SessionCode <String>] [-SupportSessionType <TeamViewerConnectionReportSessionType>] -StartDate <DateTime>
 [-EndDate <DateTime>] [-Limit <Int32>] [<CommonParameters>]
```

### RelativeDates

```powershell
Get-TeamViewerConnectionReport -ApiToken <SecureString> [-UserName <String>] [-UserId <Object>]
 [-GroupId <Object>] [-DeviceName <String>] [-DeviceId <Int32>] [-WithSessionCode] [-WithoutSessionCode]
 [-SessionCode <String>] [-SupportSessionType <TeamViewerConnectionReportSessionType>] [-EndDate <DateTime>]
 [-Months <Int32>] [-Days <Int32>] [-Hours <Int32>] [-Minutes <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION

Returns a list of TeamViewer session reports. The list can optionally be filtered
using the given parameters.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerConnectionReport
```

List all available connection reports

### Example 2

```powershell
PS /> Get-TeamViewerConnectionReport -Days 14
```

List connection reports of the last 2 weeks

### Example 3

```powershell
PS /> Get-TeamViewerConnectionReport -SessionId s1122344
```

List connection reports for the given session identifier.

### Example 4

```powershell
PS /> Get-TeamViewerConnectionReport -UserId u1234 -StartDate "2021-05-01 13:00"
```

List reports for connections of the TeamViewer account with the given user ID and
that were initiated on or after May 1st, 2021 1pm.
If specified like this, dates/times use the timezone currently configured in
your Powershell. For UTC, just add a `Z` at the end.

### Example 5

```powershell
PS /> Get-TeamViewerConnectionReport `
  -Group (Get-TeamViewerGroup -Name "My Computers" | Select-Object -First 1) `
  -StartDate "2021-04-01" -EndDate "2021-04-02"
```

List connection reports for devices in a group named `My Computers` and that
have happened between April 1st and April 2nd 2021.
This example shows the interaction with the `Get-TeamViewerGroup` cmdlet.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Days

Sets the start date to the given number of days before the end date.
If no `-EndDate` is given, this is the number of days in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId

Filter the list of connection reports by the given device identifier. This
needs to be the TeamViewer ID of the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceName

Filter the list of connection reports by the given device name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate

Sets the end for the date range of connection reports to fetch. Defaults to now.
To be included in the results the connection is required to be ended before this
date/time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId

Filter the list of connection reports by the given group ID.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Group

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hours

Sets the start date to the given number of hours before the end date.
If no `-EndDate` is given, this is the number of hours in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit

Optionally limit the results to the given number. If the limit is reached the
function stops and won't fetch more entries.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Minutes

Sets the start date to the given number of minutes before the end date.
If no `-EndDate` is given, this is the number of minutes in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Months

Sets the start date to the given number of months before the end date.
If no `-EndDate` is given, this is the number of months in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionCode

Filter the list of connection reports by the given session-code.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate

Sets the start for the date range of connection reports to get.
To be included in the results the connection is required to be started on or
after this date/time.

```yaml
Type: DateTime
Parameter Sets: AbsoluteDates
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SupportSessionType

Filter the list of connection reports by the given session type.

```yaml
Type: TeamViewerConnectionReportSessionType
Parameter Sets: (All)
Aliases:
Accepted values: RemoteConnection, RemoteSupportActive, RemoteSupportActiveSdk

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserId

Filter the list of connection reports by the given user ID.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: User

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName

Filter the list of connection reports by the given user name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithSessionCode

Filter the list of connection reports to only contain entries that have a
session code.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithoutSessionCode

Filter the list of connection reports to only contain entries that do not have a
session code assiciated to.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
