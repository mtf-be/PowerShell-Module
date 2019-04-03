# Test-MTFLogin
## Import Module 
```
 Import-Module -Name C:\Users\$env:USERNAME\Downloads\Test-MTFLogin.psm1
```

## Install Module
```
mkdir C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\Test-MTFLogin
Copy-Item C:\Users\$env:USERNAME\Downloads\Test-MTFLogin.psm1 -Destination C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\Test-MTFLogin
```

## Usage
```
Test-MTFLogin -Credentials Domain\User
```
```
Test-MTFLogin -Credentials Domain\User -SMTPServer smtp.mailserver.com -MailAdress administrator@domain.com -SMTPCredentials Domain\User
```

## What does it?
It generates a report which tells you where you can login.
