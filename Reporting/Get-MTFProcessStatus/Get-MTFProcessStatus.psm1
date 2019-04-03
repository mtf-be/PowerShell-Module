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
           $object = New-Object PSObject -Property @{ProcessName = $Process; Inputs = $result.ReadTransferCount; Outputs = $result.WriteTransferCount;}

           if($object.Inputs -eq 0 -and $object.Output -eq 0) {
                Write-EventLog -LogName Application -Source "MTF Process Test" -Message "$($object.ProcessName) has no more I/O's" -EventId 2000 -ErrorAction SilentlyContinue
           }

           $object = New-Object PSObject
        }
        
    }
    End
    {
    }
}

