<#
===============================================================================
                    Active Directory Information Report
-------------------------------------------------------------------------------
Created by: ITKB Consultant
Email: info@itkbconsultant.com
YouTube: https://www.youtube.com/@itkb
===============================================================================

Description:
This script displays:
1. Total number of Domain Controllers (numeric and words) with their FQDNs.
2. Active Directory Domain Name.
3. All five FSMO roles and their respective role holders.

Requirements:
- Run on a Domain Controller or a domain-joined computer.
- RSAT Active Directory PowerShell module must be installed.
- Appropriate permissions to query Active Directory.
===============================================================================
#>

# Import Active Directory Module
try {
    Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
    Write-Host "Error: Active Directory PowerShell module is not installed." -ForegroundColor Red
    exit
}

Clear-Host

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "           Active Directory Information Report" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

try {

    # Retrieve Domain and Forest Information
    $Domain = Get-ADDomain
    $Forest = Get-ADForest

    # Retrieve all Domain Controllers (Force Array)
    $DCs = @(Get-ADDomainController -Filter * | Sort-Object HostName)

    # Count Domain Controllers
    $DCCount = $DCs.Count

    # Number-to-Word Conversion (0-20)
    $NumberWords = @(
        "Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine",
        "Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen",
        "Seventeen","Eighteen","Nineteen","Twenty"
    )

    if ($DCCount -le 20) {
        $DCCountWord = $NumberWords[$DCCount]
    }
    else {
        $DCCountWord = $DCCount.ToString()
    }

    # -------------------------------------------------------------------------
    # Domain Name
    # -------------------------------------------------------------------------
    Write-Host "Domain Name" -ForegroundColor Green
    Write-Host "-----------"
    Write-Host $Domain.DNSRoot
    Write-Host ""

    # -------------------------------------------------------------------------
    # Domain Controllers
    # -------------------------------------------------------------------------
    Write-Host "Domain Controllers" -ForegroundColor Green
    Write-Host "------------------"
    Write-Host "Total Domain Controllers : $DCCount ($DCCountWord)"
    Write-Host ""

    $DCs |
        Select-Object @{Name = "FQDN"; Expression = { $_.HostName }} |
        Format-Table -AutoSize

    Write-Host ""

    # -------------------------------------------------------------------------
    # FSMO Role Holders
    # -------------------------------------------------------------------------
    Write-Host "FSMO Role Holders" -ForegroundColor Green
    Write-Host "-----------------"

    $FSMORoles = @(
        [PSCustomObject]@{
            "FSMO Role"  = "Schema Master"
            "Role Holder" = $Forest.SchemaMaster
        }
        [PSCustomObject]@{
            "FSMO Role"  = "Domain Naming Master"
            "Role Holder" = $Forest.DomainNamingMaster
        }
        [PSCustomObject]@{
            "FSMO Role"  = "RID Master"
            "Role Holder" = $Domain.RIDMaster
        }
        [PSCustomObject]@{
            "FSMO Role"  = "PDC Emulator"
            "Role Holder" = $Domain.PDCEmulator
        }
        [PSCustomObject]@{
            "FSMO Role"  = "Infrastructure Master"
            "Role Holder" = $Domain.InfrastructureMaster
        }
    )

    $FSMORoles | Format-Table -AutoSize

    Write-Host ""
    Write-Host "Report completed successfully." -ForegroundColor Cyan
}
catch {
    Write-Host ""
    Write-Host "An error occurred while retrieving Active Directory information." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}
