# Get-MTFSMBv1 
## Import Module
```
 Import-Module -Name C:\Users\$env:USERNAME\Downloads\Get-MTFSMBv1.psm1
```

## Install Module
```
mkdir C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\Get-MTFSMBv1
Copy-Item C:\Users\$env:USERNAME\Downloads\Get-MTFSMBv1.psm1 -Destination C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\Get-MTFSMBv1
```

## Usage
Get-MTFSMBv1 COMPUTERNAME <br />
Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Get-MTFSMBv1

## What does it?
It checks if the device has SMBv1 enabled
