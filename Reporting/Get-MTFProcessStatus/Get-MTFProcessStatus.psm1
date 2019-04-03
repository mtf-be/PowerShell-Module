<#
.Synopsis
   Untersucht ob der angegeben Prozess noch am laufen ist.
.DESCRIPTION
   Es untersucht den angegebenen Prozess ob er noch I/O's produziert oder nicht.
   Wenn der Prozess keine I/O's generiert, wird ein Eventlog in "Application/MTF Process Test" mit der EventID 2000 geschrieben.
.EXAMPLE
   Get-MTFProcessStatus -Process explorer.exe
.EXAMPLE
   Get-MTFProcessStatus -Process chrome.exe
#>
function Get-MTFProcessStatus
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
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

