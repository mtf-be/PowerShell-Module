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
   Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Get-MTFSMBv1
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
                   ValueFromPipeline=$true,
                   Position=0)]
        $Computers
    )

    Begin
    {
    $path = "C:\Users\$env:USERNAME\Documents\Powershell Exports"
    $file = "$(get-date -f yyyy-MM-dd-hh-mm-ss)_export.html"
    if(!(Test-Path $path))
        { 
            New-Item -ItemType Directory -Force -Path $path
        }
        if(!(Test-Path $path\$file))
        {
            New-Item -ItemType File -Force -Path $path\$file
            Add-Content -Path $path\$file -Value '<!DOCTYPE html><html lang="de"><head><meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><!-- Latest compiled and minified CSS --><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css"><!-- jQuery library --><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script><!-- Latest compiled JavaScript --><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script> <title>MTFSMBv1 Powershell html Export</title></head><body><div class="container"><h2>Get-MTFSMBv1 Export</h2><table class="table"><thead><tr><th>Servername</th><th>Result</th><th>Description</th></tr></thead><tbody>'
        }
    }
    Process
    {
        $SMBState = (Get-SmbServerConfiguration).EnableSMB1Protocol

        try
        {
            foreach($Computer in $Computers){
                $Check = Invoke-Command -ComputerName $Computer -ScriptBlock {$Using:SMBState} 
                $html1 = '<tr class="success"><td>'
                $html2 = '</td><td>Succes</td><td>SMBv1 is enabled</td></tr>'
                Add-Content -Path $path\$file -Value "$html1 $computer $html2"

                


            } 
        }
        catch
        {
            $html3 = '<tr class="danger"><td>'
            $html4 = '</td><td>Failure</td><td>Not able to connect...is WinRM on? If not, SMBv1 is disabled</td></tr>'

            Add-Content -Path $path\$file -Value "$html3 $computer $html4"
        }
        finally
        {
            #$html3 = '<tr class="danger"><td>'
            #$html4 = '</td><td>Failure</td><td>SMBv1 is disabled</td></tr>'
            #Add-Content -Path $path\$file -Value "$html3 $computer $html4"
        }
    }
    End
    {
        Add-Content -Path $path\$file -Value '</tbody></table></div></body></html><body>'
        start $path\$file
    }
} 