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
   Test-MTFLogin -Credentials Domain\User -Password DEINPASSWORT
.EXAMPLE
   Test-MTFLogin -Credentials Domain\User -SMTPServer smtp.mailserver.com -MailAdress administrator@domain.com -SMTPCredentials Domain\User
#>
function Test-MTFLogin
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Credentials = [System.Management.Automation.PSCredential]::Empty,

        
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $password = [System.Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$SMTPServer = "",


        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [string]$MailAdress = "",


        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        $SMTPCredentials = [System.Management.Automation.PSCredential]::Empty
    )

    Begin
    {
    }
    Process
    {
        New-EventLog -LogName Application -Source "MTF Login Test" -ErrorAction Ignore
        
        $pass = ConvertTo-SecureString -AsPlainText $password -Force
        $SecureString = $pass

        $MyCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Credentials,$SecureString

        $time = (Get-Date).AddDays(-90)
        $servers = Get-ADComputer -Filter {LastLogonDate -gt $time -and OperatingSystem -like "Windows Server*"} -Properties * | Select Name -ExpandProperty Name

        try {
            foreach ($server in $servers) {
                if(Test-Connection $server -Count 3 -ErrorAction SilentlyContinue) {
                    if(New-PSDrive -Name ConnectionTest -PSProvider FileSystem -Root "\\$server\c$" -Credential $MyCred -ErrorAction SilentlyContinue) {
                        $status = "online and able to connect"
                        Remove-PSDrive ConnectionTest
                    }
                    else {
                        $status = "online but unable to connect"
                       Write-EventLog -LogName Application -Source "MTF Login Test" -EventId 2000 -EntryType Error -Message "Couldn't connect to $server ..."
                    }
                }
                else {
                    $status = "$offline/not in DNS"
                    Write-EventLog -LogName Application -Source "MTF Login Test" -EventId 2000 -EntryType Error -Message "$server is offline..."
                }

                Write-Host $server" "$status

                $result = New-Object PSObject -Property @{Server = $server; Status = $status}
                Export-Csv -InputObject $result -Path "C:\Temp\Result.csv" -Append -NoTypeInformation 
                Write-EventLog -LogName Application -Source "MTF Login Test" -EventId 1000 -EntryType Information -Message $result 
            }
        }
        catch{
            Write-Error "Couldn't execute anything..."
            Write-EventLog -LogName Application -Source "MTF Login Test" -EventId 2000 -EntryType Error -Message "Couldn't execute anything..."
        }
        finally{
        }

       # Send-MailMessage -From $MailAdress -To $MailAdress -Subject 'Result Login Test' -Attachments "C:\Temp\Result.csv" -SmtpServer $SMTPServer -Credential $SMTPCredentials -UseSsl -ErrorAction Ignore
    }
    End
    {
         Write-Information "You will find the result under C:\Temp\Result.csv"
    }
}