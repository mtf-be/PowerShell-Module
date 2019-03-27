# PowerShell-Modules
## Import Module 
```
 Import-Module -Name C:\Users\$env:USERNAME\Downloads\**ModuleName**.psm1
```

## Install Module
```
mkdir C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\**ModuleName**
Copy-Item C:\Users\$env:USERNAME\Downloads\**ModuleName**.psm1 -Destination C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\**ModuleName**
```
