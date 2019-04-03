<#
.Synopsis
   Kurzbeschreibung
.DESCRIPTION
   Lange Beschreibung
.EXAMPLE
   Beispiel für die Verwendung dieses Cmdlets
.EXAMPLE
   Ein weiteres Beispiel für die Verwendung dieses Cmdlets
#>
function Get-MTFProcessStatus
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Hilfebeschreibung zu Param1
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Process
    )

    Begin
    {
    }
    Process
    {
        New-EventLog -LogName Application -Source "MTF Process Test" -ErrorAction Ignore

        while($true) {
           $result = Get-WmiObject -Class Win32_Process | Where {$_.Caption -eq $Process}
           $object = New-Object PSObject -Property @{ProcessName = $Process; Inputs = $result.ReadTransferCount; Outputs = $result.WriteTransferCount}


$message = @"
ProcessName: $($object.ProcessName)
Inputs: $($object.Inputs)
Outputs: $($object.Outputs)
"@

           Write-EventLog -LogName Application -Source "MTF Process Test" -EventId 1000 -EntryType Information -Message "$message"

           $object = New-Object PSObject
        }
        
    }
    End
    {
    }
}

