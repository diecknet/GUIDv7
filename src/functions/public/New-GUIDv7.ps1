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