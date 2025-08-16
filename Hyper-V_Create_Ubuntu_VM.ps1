<#
.SYNOPSIS


.DESCRIPTION


.NOTES
    Author: Al Robison
    Last modified: 2025-08-16
#>

function Get-FreeDiskSpace {
    param(
        [string]$DriveLetter
    )

    try {
        $drive = Get-PSDrive -Name $DriveLetter
        $
    }
    catch {
        <#Do this if a terminating exception happens#>
    }
}

function Test-DiskSpace {
    param(
        [uint32]$MinimumRequiredSpace,
        [bool]$FreeDiskSpace
    )

    # compares the values of Get-FreeDiskSpace and the requirements
}