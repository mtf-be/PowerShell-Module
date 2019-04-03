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
Test-MTFLogin 

## What does it?
It generates an eventlog (ID 2000 in Application) when the process (defined with -Process) doesn't generates any I/O's
