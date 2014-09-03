[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true,Position=0)]
        [string]$Target,
    [Parameter(Mandatory=$true,Position=1)]
        [string]$FileName,
    [Parameter(Mandatory=$false,Position=2)]
        [switch]$Ascii,
    [Parameter(Mandatory=$false,Position=3)]
        [System.Management.Automation.PSCredential]$Creds
)

[scriptblock]$sb = {
    Param(
        [Parameter(Mandatory=$true,Position=0)]
            [string]$FileName
    )

    if(Test-Path $FileName -PathType Leaf) {
        $sr = New-Object IO.StreamReader $FileName

        while(($line = $sr.ReadLine()) -ne $null) {
            $line
        }
    }
}

Write-Verbose "Set encoding"
if($Ascii) {
    Set-Variable -Name Encoding -Value "Ascii" -Scope Script
}
else {
    Set-Variable -Name Encoding -Value "Unicode" -Scope Script
}

Write-Verbose "Setup session"
if($Creds) {
    $PSSession = New-PSSession -ComputerName $Target -SessionOption (New-PSSessionOption -NoMachineProfile) -Credential $Creds
}
else {
    $PSSession = New-PSSession -ComputerName $Target -SessionOption (New-PSSessionOption -NoMachineProfile)
}

if ($PSSession) {
    Write-Verbose "In session"
    $Job = Invoke-Command -Session $PSSession -ScriptBlock $sb -ArgumentList $FileName -AsJob
    
    if($Job) {
        $suppress = Wait-Job $Job

        foreach($ChildJob in $Job.ChildJobs) {
            $Recpt = Receive-Job $ChildJob

            $OutFile = Join-Path $PSScriptRoot $Target
            $OutFile = Join-Path $OutFile ($FileName -replace "\\|:", "_")

            if( -not (Test-Path $OutFile)) {
                New-Item $OutFile -ItemType file -Force
            }

            $Recpt | Set-Content -Encoding $Encoding $OutFile
        }
    }
}