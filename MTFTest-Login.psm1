<#
.Synopsis
   Generiert ein Report welcher beschreibt auf welchen Windows Servern sich anmelden kann.
.DESCRIPTION
   Generiert ein Report welcher beschreibt auf welchen Windows Servern sich anmelden kann.
   Es filtert jedes Gerät raus welches nicht seit 90 Tagen ein Logon hatte.

   === Wichtig ===
   Die Variable "MailAdress" ist für Empfänger und Absender.
   Die Variable "SMTPCredentials" ist für den Mailbox Zugriff
.EXAMPLE
   MTFTest-Login -Credentials Domain\User -SMTPServer smtp.mailserver.com -MailAdress administrator@domain.com -SMTPCredentials Domain\User
#>
function MTFTest-Login
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [System.Management.Automation.PSCredential]$Credentials = "Get-Credential",


        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$SMTPServer = "",


        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [string]$MailAdress = "",


        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        [System.Management.Automation.PSCredential]$SMTPCredentials = "Get-Credential"
    )

    Begin
    {
    }
    Process
    {
        $time = (Get-Date).AddDays(-90)
        $servers = Get-ADComputer -Filter {LastLogonDate -gt $time -and OperatingSystem -like "Windows Server*"} -Properties * | Select Name -ExpandProperty Name

        try {
            foreach ($server in $servers) {
                if(Test-Connection $server -Count 3 -ErrorAction SilentlyContinue) {
                    if(New-PSDrive -Name ConnectionTest -PSProvider FileSystem -Root "\\$server\c$" -Credential $cred -ErrorAction SilentlyContinue) {
                        $status = "online and able to connect"
                        Remove-PSDrive ConnectionTest
                    }
                    else {
                        $status = "online but unable to connect"
                    }
                }
                else {
                    $status = "$offline/not in DNS"
                }

                Write-Host $server" "$status

                $result = New-Object PSObject -Property @{Server = $server; Status = $status}
                Export-Csv -InputObject $result -Path "C:\Temp\Result.csv" -Append -NoTypeInformation 
            }
        }
        catch{
            Write-Error "Couldn't execute anything..."
        }
        finally{
        }

        Send-MailMessage -From $MailAdress -To $MailAdress -Subject 'Result Login Test' -Attachments "C:\Temp\Result.csv" -SmtpServer $SMTPServer -Credential $SMTPCredentials -UseSsl
    }
    End
    {
         Write-Information "You will find the result under C:\Temp\Result.csv"
    }
}