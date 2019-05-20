<#
.Synopsis
   Checkt ob SMBv1 aktiviert ist.
.DESCRIPTION
   Checkt ob SMBv1 aktiviert ist.
   Das CMDLET muss als Administrator ausgeführt werden!
   Man muss beachten, dass auf dem Zielsystem der Dienst WinRM läuft.
.EXAMPLE
   Get-MTFSMBv1 COMPUTERNAME
.EXAMPLE
   Get-ADComputer -Filter * | Get-MTFSMBv1
#>
function Get-MTFSMBv1
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Computers
    )

    Begin
    {
    }
    Process
    {
        $SMBState = (Get-SmbServerConfiguration).EnableSMB1Protocol

        try
        {
            foreach($Computer in $Computers){
                $Check = Invoke-Command -ComputerName $Computer -ScriptBlock {$Using:SMBState} 
                Write-Host "SMBv1 state: $Check on $Computer"
            } 
        }
        catch
        {
            Write-Host "Couldn't connect...is WinRM on?"
        }
        finally
        {

        }
    }
    End
    {
    }
}