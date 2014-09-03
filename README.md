ps-responder
============

Collection of PowerShell functions I've found useful in my incident response work.

## Get-FileHash.ps1

Based on various samples found around the web, but not fully derived from any of
them. Reads a file as a byte array and calculates a cryptographic hash of the
contents. Defaults to MD5, but supports SHA1, SHA256, SHA384, SHA512, and
RIPEMD160 as well. On PowerShell v4+ systems, there is a built-in function for
this.

### Examples
```powershell
PS> .\Get-FileHash.ps1 .\Get-FileHash.ps1 | fl

Name  : C:\Source\git\ps-responder\Get-FileHash.ps1
Value : C5B21E10EC894EC1979E2C35C7CD45FA

PS> .\Get-FileHash.ps1 .\Get-FileHash.ps1 -HashType SHA256 | fl

Name  : C:\Source\git\ps-responder\Get-FileHash.ps1
Value : B21C2CA99C1497D9414A9004E6816152A4172CCAD5007D1B06893DFA8EF79086
```

## Get-RemoteFiles.ps1

Creates a PowerShell remoting session to the designated host (optionally with
alternative credentials) and pulls back the requested file.

### Examples
```powershell
PS> .\Get-RemoteFiles.ps1 -Target HW-PRODWEB-001 -FileName "C:\inetpub\wwwroot\index.html"

PS> Get-ChildItem .\HW-PRODWEB-001

    Directory: C:\Source\git\ps-responder\HW-PRODWEB-001

Mode                LastWriteTime     Length Name
----                -------------     ------ ----
-a---          9/3/2014     13:09      10342 C__inetpub_wwwroot_index.html
```