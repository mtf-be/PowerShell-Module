# Get-MTFProcessStatus
## Import Module 
```
 Import-Module -Name C:\Users\$env:USERNAME\Downloads\Get-MTFProcessStatus.psm1
```

## Install Module
```
mkdir C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\Get-MTFProcessStatus
Copy-Item C:\Users\$env:USERNAME\Downloads\Get-MTFProcessStatus.psm1 -Destination C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\Get-MTFProcessStatus
```

## Usage
Get-MTFProcessStatus -Process explorer.exe

## What does it?
It generates an eventlog (ID 2000 in Application) when the process (defined with -Process) doesn't generates any I/O's
