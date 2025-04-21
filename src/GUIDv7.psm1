function Get-DateTimeOffsetFromGUIDv7 {
    <#
    .SYNOPSIS
    Converts a version 7 GUID to a DateTimeOffset representing the timestamp encoded in the GUID.

    .DESCRIPTION
    The `Get-DateTimeOffsetFromGUIDv7` function extracts the timestamp from a version 7 GUID and converts it to a `DateTimeOffset` object. 
    Version 7 GUIDs are time-ordered and include a timestamp in their first 6 bytes. This function decodes that timestamp and returns it 
    as a `DateTimeOffset` object.

    .PARAMETER GUID
    The version 7 GUID to be converted. The GUID must be of version 7; otherwise, an error will be thrown. 
    The function validates the GUID version before processing.

    .INPUTS
    [Guid]
    The function accepts a GUID object as input, either from the pipeline or as a direct parameter.

    .OUTPUTS
    [DateTimeOffset]
    The function outputs a `DateTimeOffset` object representing the timestamp encoded in the version 7 GUID.

    .EXAMPLE
    PS> $guid = [Guid]::CreateVersion7()
    PS> Get-DateTimeOffsetFromGUIDv7 -GUID $guid

    This example demonstrates how to pass a GUID to the function and retrieve the corresponding `DateTimeOffset`.

    .EXAMPLE
    PS> New-GUIDv7 | Get-DateTimeOffsetFromGUIDv7

    This example demonstrates how to pipe a GUID directly to the function.
    The used cmdlet `New-GUIDv7` is part of the same module and generates a new version 7 GUID.

    .NOTES
    - This function only works with version 7 GUIDs. If a GUID of a different version is provided, an error will be thrown.
    - The function handles endianness to ensure compatibility across systems.

    .LINK
    https://github.com/diecknet/GUIDv7
    #>
    
    [Alias("Convert-GUIDv7")]
    [CmdletBinding()]
    [OutputType([DateTimeOffset])]
    param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$true
        )]
        [ValidateScript({
            if($_.Version -eq 7) {
                return $true
            } else {
                throw [System.ArgumentException]::new("The GUID must be a version 7 GUID. It looks like the provided GUID '$_' is version $($_.Version).")
            }
        })]
        [Guid]$GUID
    )

    process {
        try {
            # Create an empty 8-byte array
            $bytes = [byte[]]::new(8)

            # Convert the GUID to a byte array (16 bytes)
            $GUIDBytes = $GUID.ToByteArray($true)

            # Copy the first 6 bytes of the GUID byte array into positions 2-7 of the 8-byte array
            [Array]::Copy($GUIDBytes, 0, $bytes, 2, 6)

            # Reverse if system is little-endian
            if ([BitConverter]::IsLittleEndian) {
                [Array]::Reverse($bytes)
            }

            # Convert bytes to Int64
            $ms = [BitConverter]::ToInt64($bytes, 0)

            # Return DateTimeOffset from Unix milliseconds
            return [DateTimeOffset]::FromUnixTimeMilliseconds($ms)
        } catch {
            Write-Error "An error occurred while converting the GUID: $_"
            return $null
        }
    }
}
function New-GUIDv7 {
    <#
    .SYNOPSIS
    Generates a new Version 7 GUID (UUIDv7).

    .DESCRIPTION
    The `New-GUIDv7` function generates a new Version 7 GUID (UUIDv7) based on the current timestamp or a specified `DateTimeOffset`. 
    Version 7 GUIDs are time-based and work well for cases where unique IDs with a time order are needed.

    .PARAMETER DateTimeOffset
    Specifies the `DateTimeOffset` to use for generating the Version 7 GUID. If not provided, the current timestamp is used.

    .INPUTS
    [DateTimeOffset]
    You can pipe a `DateTimeOffset` object to this function to generate a Version 7 GUID based on the provided timestamp.

    .OUTPUTS
    [Guid]
    The function outputs a Version 7 GUID.

    .EXAMPLE
    PS C:\> New-GUIDv7
    This example demonstrates how to generate a new Version 7 GUID using the current timestamp. The GUID will be based on the current date and time.

    .EXAMPLE
    PS C:\> New-GUIDv7 -DateTimeOffset (Get-Date "2023-01-01T12:00:00Z")
    This example demonstrates how to generate a Version 7 GUID using a specific `DateTimeOffset`. The GUID will be based on the provided timestamp.

    .EXAMPLE
    PS C:\> [DateTimeOffset]::Now | New-GUIDv7
    This example demonstrates how to pipe a `DateTimeOffset` object to the function. The function will generate a Version 7 GUID based on the provided timestamp.

    .NOTES
    This function requires the .NET implementation of Version 7 GUIDs. Ensure your environment supports this feature.
    Should be available in .NET 9.0 and later (PowerShell 7.5+).

    .LINK
    https://github.com/diecknet/GUIDv7
    #>

    [CmdletBinding()]
    [OutputType([Guid])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Does not modify system state.")]
    param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [DateTimeOffset]$DateTimeOffset
    )

    process {
        if($null -eq $DateTimeOffset) {
            [guid]::CreateVersion7()
        } else {
            [guid]::CreateVersion7($DateTimeOffset)
        }
    }
}
