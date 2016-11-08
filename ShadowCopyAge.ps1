<#
.Synopsis
   Returns the age in days of the oldest shadow copy for each volume on a server.
.DESCRIPTION
   Long description
.EXAMPLE
   Get-ShadowCopyAge -ComputerName Dave

   Returns the age of the oldest shadow copy of each volume on computer Dave for which shadow copies are configured
.EXAMPLE
   Get-ShadowCopyAge -ComputerName Dave, Mike

   The function will accept multiple rnames for the ComputerName parameter
#>
function Get-ShadowCopyAge
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [String[]]
        $ComputerName
    )

    Begin
    {
    # We only need to get the datetime once!
    $Now = Get-Date
    }
    Process
    {
    $ShadowCopies = Get-WmiObject win32_ShadowCopy -ComputerName $ComputerName | Where ClientAccessible
    Write-Verbose "Got ShadowCopies"

    $Volumes = Get-WmiObject Win32_Volume -ComputerName $ComputerName
    Write-Verbose "Got Volumes"

    $OldestCopy = $ShadowCopies | Group-Object -Property VolumeName | foreach {$_.Group | Select -first 1}

    foreach ($item in $OldestCopy)
        {
        $Volume = $Volumes | where {$_.DeviceID -like $item.VolumeName} | select -ExpandProperty Name
        $Then =  Get-Date ([management.managementDateTimeConverter]::ToDateTime($item.InstallDate))
        $Age = New-TimeSpan -Start $Then -End $Now

        [pscustomobject]@{Volume       = $Volume
                          ComputerName = $item.PSComputerName
                          DaysOld      = $age.Days}
        }
    }
    End
    {
    }
}