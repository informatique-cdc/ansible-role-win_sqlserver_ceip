

#Requires -Module Ansible.ModuleUtils.Legacy
#Requires -Version 2.0

$ErrorActionPreference = "Stop"
$ConfirmPreference = "None"

$result = @{ }

$params = Parse-Args -arguments $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false
$diff_mode = Get-AnsibleParam -obj $params -name "_ansible_diff" -type "bool" -default $false

# Modules parameters

$state = Get-AnsibleParam -obj $params "state" -type "str" -default "present" -validateSet "present", "absent" -resultobj $result

$result = @{
    changed = $false
}

if ($diff_mode) {
    $result.diff = @{ }
}

# CODE

Function Get-TargetResource {
    [OutputType([System.Collections.Hashtable])]

    [array]$services = Get-Service | 
        Where-Object { $_.Name -like '*telemetry*' -or $_.DisplayName -like '*CEIP*' } |    
        ForEach-Object { 
            @{
                Name        = $_.Name
                DisplayName = $_.DisplayName
                StartType   = $_.StartType
            }
        }

    Set-Location "HKLM:\"
    $sqlentries = @( "\Software\Microsoft\Microsoft SQL Server\", "\Software\Wow6432Node\Microsoft\Microsoft SQL Server\" ) 

    [array]$registry = Get-ChildItem -Path $sqlentries -Recurse -ErrorAction SilentlyContinue |
        ForEach-Object {
            $keypath = $_.Name
            (Get-ItemProperty -Path $keypath).PSObject.Properties |
                Where-Object { $_.Name -eq "CustomerFeedback" -or $_.Name -eq "EnableErrorReporting" } |
                ForEach-Object {
                    @{
                        Name  = $_.Name
                        Value = Get-ItemPropertyValue -Path $keypath -Name $_.Name
                        Path  = $keypath 
                    }
                }
        }
    return @{
        Services = $services
        Registry = $registry
    }
}

Function Test-TargetResource {
    [OutputType([System.Boolean])]
    param (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present", "Absent")]
        [string]
        $state
    )

    $DesiredState = Get-TargetResource

    if ($state -eq 'present') {
        $StartupType = 'Automatic'
        $RegistryValue = 1

    }
    else {   
        $StartupType = 'Disabled'
        $RegistryValue = 0        
    }

    $IsDesiredState = $true

    $DesiredState.Services | ForEach-Object {
        if ($_.StartType -ne $StartupType) {
            $IsDesiredState = $false
        }
    }
    if (!$IsDesiredState) {
        return $false
    }

    $DesiredState.Registry | ForEach-Object {
        if ($_.Value -ne $RegistryValue) {
            $IsDesiredState = $false
        }
    }
    return $IsDesiredState
}


Function Set-TargetResource {
    [OutputType([System.Boolean])]
    param (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present", "Absent")]
        [string]
        $state
    )

    $IsCompliant = Test-TargetResource -State $State
    if ($IsCompliant) {
        return $false
    }

    if ($state -eq 'present') {
        $StartupType = 'Automatic'
        $RegistryValue = 1

    }
    else {   
        $StartupType = 'Disabled'
        $RegistryValue = 0        
    }

    $CurrentState = Get-TargetResource

    $CurrentState.Registry | ForEach-Object {
        if ($_.Value -ne $RegistryValue) {
            $Path = $_.Path
            $itemporpertyname = $_.Name
            Set-ItemProperty -Path $Path -Name $itemporpertyname -Value $RegistryValue
        }
    }

    $CurrentState.Services | ForEach-Object {
        if ($_.StartType -ne $StartupType) {
            $ServiceName = $_.Name
            Set-Service -Name $ServiceName -StartupType $StartupType -ErrorAction SilentlyContinue

            $serviceinfo = Get-Service -Name $ServiceName 
            if (($serviceinfo.Status -eq 'running') -and ($StartupType -eq 'Disabled')) {
                Stop-Service -Name $ServiceName -ErrorAction SilentlyContinue
            }
            elseif (($serviceinfo.Status -eq 'stopped') -and ($StartupType -eq 'Automatic')) { 
                Start-Service -Name $ServiceName -ErrorAction SilentlyContinue
            }
        }
    }
    return $true
}

$desiredState = @{
    State = $state
}

$changed = Set-TargetResource @DesiredState

$result.changed = $changed

Exit-Json -obj $result
