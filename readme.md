# PowerShell module GUIDv7

This module helps interacting with v7 GUIDs (see [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562.html#name-uuid-version-7)).  
It requires .NET 9.0 or later (which PowerShell 7.5 or later is based on).

## Install

The module is [available from the PowerShell Gallery](https://www.powershellgallery.com/packages/GUIDv7).

```powershell
Install-PSResource GUIDv7
```

## Demo / Videos

There is a longer German Video here: <https://youtu.be/mE4cZlL_4Xc>  
And a shorter English Video here: <https://www.youtube.com/shorts/9E6xtKzKy0I> (⚠️ Vertical Video Warning ⚠️)

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

### Example 6: Demonstrate that GUIDv7 are sortable by date

```powershell
$GUIDTest = for($i = 0; $i -lt 10; $i++) {
    New-GUIDv7 -DateTimeOffset ((Get-Date).AddDays((Get-Random -Minimum -10000 -Maximum 10000)).AddSeconds((Get-Random -Minimum -10000 -Maximum 10000)))
}
foreach($GUID in ($GUIDTest | Sort-Object)) {
    $DateTimeOffset = Get-DateTimeOffsetFromGUIDv7 -GUID $GUID
    if ($null -eq $DateTimeOffset) {
        Write-Host "Failed to get DateTimeOffset from GUIDv7: $GUID"
    } else {
        Write-Host "$GUID = $($DateTimeOffset.LocalDateTime)"
    }
}
```

```output
00e6edbf-334f-7da0-a038-3bafbf4e653d = 06/06/2001 14:40:08
0108ba7b-e88f-7e8a-84be-d457be0fcd7c = 01/11/2006 18:20:48
01234257-f528-76eb-8fb3-f6d2c37a63d8 = 08/22/2009 15:42:23
0124818f-ce65-7565-a038-c92b61e9cbe3 = 10/23/2009 15:22:15
01666d81-75b0-77d6-9d90-5a960e8054ee = 10/13/2018 14:58:12
017425d7-8687-7ad2-95a7-7e2f046e72cd = 08/25/2020 15:38:35
01e774b6-3e98-7d88-bf6f-27d441aa8f1c = 05/05/2036 15:32:53
020b7203-f517-7b30-a115-2a69a8266acc = 03/29/2041 15:39:17
02172c45-f5d7-7e63-8965-84b39fe6192a = 11/02/2042 15:11:25
022eba98-51e7-78de-a684-0f243b02c54d = 01/16/2046 14:31:35
```
