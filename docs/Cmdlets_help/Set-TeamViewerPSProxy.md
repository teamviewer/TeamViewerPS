---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: 
schema: 2.0.0
---

# Set-TeamViewerPSProxy

## SYNOPSIS

Set TeamViewerPS to use proxy.

## SYNTAX

```powershell
Set-TeamViewerPSProxy [-ProxyUri] <Uri> [<CommonParameters>]
```

## DESCRIPTION

Sets a Proxy to access webAPI for TeamViewerPS module functions.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerPSProxy -ProxyUri "http://example.com/port"
```

Sets the proxy server to "<http://example.com/port>".

### Example 2

```powershell
PS /> Set-TeamViewerPSProxy -ProxyUri "http://10.0.0.1:3128"
```

Sets the proxy server to "<http://10.0.0.1:3128>".

## PARAMETERS

### -ProxyUri

The Proxy server Uri.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
