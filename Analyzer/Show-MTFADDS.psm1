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
function Show-MTFADDS
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
        $Credentials = [System.Management.Automation.PSCredential]::Empty,

        # Hilfebeschreibung zu Param2
        [int]
        $Param2
    )

    Begin
    {
    }
    Process
    {
        Write-Host "Welcome to the analyzer" -ForegroundColor Yellow
        Write-Host "Start scanning Domain Admin Group" -ForegroundColor Yellow
### Scan 1 Start
        try {
            $ScanResult1 = Get-ADGroupMember "Domain Admins" | Select-Object Name, DistinguishedName -ErrorAction Continue
            Write-Host "Scanned the Domain Admin Group. Generate Report Part..."

            $ScanResult1Object = @()
            $ScanResult1Object = Get-ADGroupMember "Domain Admins"

            foreach($object in $ScanResult1Object) {
                $User = @{"User" = $ScanResult1Object}
                $UserContentName = $User.Name
                $UserContentDistinguishedName = $User.DistinguishedName
            }

$Header = @"
<style>
TH {background-color:DeepSkyBlue; Opacity:0.8;}
TABLE {border-width:1px; border-style:solid; text-align:center; margin-left:auto; margin-right:auto;}
TD {border-style:ridge;}
IMG {width:200px; height:100px;}
P {text-align:center; padding-left:70px; padding-right:70px;}
</style> 
"@

            $ScanResult1Object | Select-Object Name,DistinguishedName | ConvertTo-Html -Head $Header -PreContent "<center><center><img src='https://hilfe.mtf-be.ch/img/mtflogo.png'><br><h1>MTF Analyzer Report</h1></center></center><br><center><h2>Scan 1: Clean Domain Admin Group</h2><p>There should be no day to day user accounts in the Domain Admins group, the only exception is the default Domain Administrator account. Members of the DA group are to powerful. They have local admin rights on every domain joined system (workstation, servers, laptops, etc). This is what the bad guys are after. Microsoft recommends that when DA access is needed, you temporarily place the account in the DA group. When the work is done you should remove the account from the DA group. This process is also recommended for the Enterprise Admins, Backup Admins and Schema Admin groups.</p></center>" -As Table | Out-File "C:\Temp\ADDSAnaylzerReport.html" -Append
            
            
        }
        catch {
            Write-Host "Can't scan or write the output file!"
        }
        finally{

        }
### Scan 1 End
### Scan 2 Start
        Write-Host ""
### Scan 2 End

    }
    End
    {
    }
}