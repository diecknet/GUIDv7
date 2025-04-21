# PowerShell module GUIDv7

This module helps interacting with v7 GUIDs (see [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562.html#name-uuid-version-7)).  
It requires .NET 9.0 or later (which PowerShell 7.5 or later is based on).

## Install

The module is [available from the PowerShell Gallery](https://www.powershellgallery.com/packages/GUIDv7).

```powershell
Install-PSResource GUIDv7
```

## Usage examples

### Example 1: Generate a GUIDv7 based on the current date/time

```powershell
New-GUIDv7
```

```output
Guid
----
01965890-1915-7d89-96f5-b660ee72e5fa
```

### Example 2: Generate a GUIDv7 based on a specific date/time

```powershell
New-GUIDv7 -DateTimeOffset (Get-Date "2023-10-01 00:00:00")
```

```output
Guid
----
018ae81b-0700-7e66-b050-3a166600f7c4
```

### Example 3: Generate a GUIDv7 by piping a date to the cmdlet

```powershell
Get-Date "2024-06-06 15:00:00" | New-GUIDv7
```

```output
Guid
----
018feda2-7c80-7d40-8dee-ccb2974db838
```

### Example 4: Get the `[DateTimeOffset]` from a GUIDv7

```powershell
$GUID = "01965893-c0aa-722e-8dd0-151b5bba56e3"
Get-DateTimeOffsetFromGUIDv7 -GUID $GUID
```

```output
DateTime           : 21/04/2025 13:40:00
UtcDateTime        : 21/04/2025 13:40:00
LocalDateTime      : 21/04/2025 15:40:00
Date               : 21/04/2025 00:00:00
Day                : 21
DayOfWeek          : Monday
DayOfYear          : 111
Hour               : 13
Millisecond        : 298
Microsecond        : 0
Nanosecond         : 0
Minute             : 40
Month              : 4
Offset             : 00:00:00
TotalOffsetMinutes : 0
Second             : 0
Ticks              : 638808396002980000
UtcTicks           : 638808396002980000
TimeOfDay          : 13:40:00.2980000
Year               : 2025
```

### Example 5: Get the local time from a GUIDv7

```powershell
$GUID = "01965893-c0aa-722e-8dd0-151b5bba56e3"
(Get-DateTimeOffsetFromGUIDv7 -GUID $GUID).LocalDateTime
```

```output
# depends on the localization. but for example:
Monday, 21 April 2025 15:40:00
```
