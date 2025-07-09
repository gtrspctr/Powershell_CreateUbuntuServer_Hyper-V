<#
.SYNOPSIS


.DESCRIPTION

#>

# Define URLs
$base_lookup_url = "https://releases.ubuntu.com"
$download_dir = "C:\LocalShit"
$ProgressPreference = "SilentlyContinue"

# Get available versions
function Get-AvailableVersions {
    $page_data = Invoke-WebRequest -Uri $base_lookup_url -UseBasicParsing
    $links = $page_data.Links | Where-Object -Property "href" -Match "^\d{2}\.\d{2}(\.\d+)?/$" | Select-Object -ExpandProperty "href"

    return $links.Replace("/", "")
}

# Display available versions
$available_versions = Get-AvailableVersions
$counter = 1
$prompt = @"
Which version do you want to download?
$(foreach ($version in $available_versions){"$counter. $version`n";$counter += 1})
Your answer
"@
$response = Read-Host -Prompt $prompt
$combined_url = "$base_lookup_url/$($available_versions[$response - 1])"

# Get download link
function Get-DownloadLink {
    param (
        [string]$Uri
    )

    $page_data = Invoke-WebRequest -Uri $Uri -UseBasicParsing
    $link = $page_data.Links | Where-Object -Property "href" -Match "live-server-amd64.iso$" | Select-Object -ExpandProperty "href" -Unique

    return $link
}

# Download file
$link = Get-DownloadLink -Uri $combined_url
$outfile = "$download_dir\$link"
Invoke-WebRequest -Uri "$combined_url/$link" -Outfile $outfile

################################################

# Define Ubuntu .iso URL and outfile
$iso_url = "https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
$iso_outfile = "C:\HYPER-V\ubuntu-22.04.3-live-server-amd64.iso"

# Local paths for VM
$vm_name = "ubuntu"
$vm_path = "C:\HYPER-V\$vm_name"
$vhd_path = "$vm_path\$vm_name.vhdx"

# VM settings
$switch_name = "New Virtual Switch"
$memory_size = 2GB
$vhd_size = 10GB
$generation = 2
$secure_boot = "Off"

# Verify VM path exists and create it if it doesn't
if (-Not (Test-Path -Path $vm_path)) {
    Write-Host "Path not found. Creating..."
    New-item -ItemType Directory -Path $vm_path | Out-Null
    if (Test-Path -Path $vm_path) {
        Write-Host "Path created: $vm_path"
    } else {
        Write-Host "Unable to create path: $vm_path"
        Write-Host "Please run script as an Administrator or create path manually."
        return "Fix errors and retry."
    }
}

# Verify Hyper-V is installed
Import-Module -Name "Hyper-V" -ErrorAction SilentlyContinue
$hv_installed = Get-Module -Name "Hyper-V"
if (-Not $hv_installed) {
    Write-Host "Hyper-V module not found by Powershell. Please ensure Hyper-V is installed and running."
    return "Fix errors and retry."
} else {
    Write-Host "Verified:  Hyper-V exists"
}

# Verify Virtual Switch has been created
$switch_exists = Get-VMSwitch | Where-Object -Property Name -eq $switch_name
if (-Not $switch_exists) {
    Write-Host "Virtual switch named $switch_name not found. Please ensure the switch has been created and the variable value is correct."
    return "Fix errors and retry."
} else {
    Write-Host "Verified:  Virtual Switch exists"
}

# Verify a VM with the same name doesn't already exist
if (Get-VM -Name $vm_name -ErrorAction SilentlyContinue) {
    Write-Host "A VM with the name $vm_name already exists. Please choose a different VM name on line 6."
    return "Fix errors and retry."
} else {
    Write-Host "Verified:  Unique VM name"
}

# Download ubuntu installer
$ProgressPreference = "SilentlyContinue"  # Disables progress bar, speeding up download
if (-Not (Test-Path -Path $iso_outfile)) {
    Write-Host "Downloading Ubuntu .iso..."
    Invoke-WebRequest -Uri $iso_url -Outfile $iso_outfile
    Write-Host "File downloaded."
}

# Create VM
Write-Host "Creating virtual machine '$vm_name'..."
New-VM -Name $vm_name `
    -MemoryStartupBytes $memory_size `
    -Path $vm_path `
    -NewVHDPath $vhd_path `
    -NewVHDSizeBytes $vhd_size `
    -Generation $generation `
    -SwitchName $switch_name  `
    -Force
Write-Host "Virtual machine '$vm_name' created."

# Mount iso
Write-Host "Mounting .iso..."
Add-VMDvdDrive -VMName $vm_name `
    -Path $iso_outfile
Write-Host ".iso mounted."

# Set VM firmware options
Write-Host "Configuring VM firmware options..."
Set-VMFirmware -VMName $vm_name `
    -EnableSecureBoot $secure_boot `
    -BootOrder $(Get-VMDvdDrive -VMName $vm_name),
                $(Get-VMHardDiskDrive -VMName $vm_name),
                $(Get-VMNetworkAdapter -VMName $vm_name)
Write-Host "VM firmware options configured."

# Start VM and verify it is running
Write-Host "Booting VM '$vm_name'..."
Start-VM -VMName $vm_name | Out-Null
Start-Sleep -Seconds 5
$vm_state = (Get-VM -VMName $vm_name).State
if ($vm_state -eq "Running") {
    Write-Host "VM '$vm_name' booted."
    Write-Host "Continue installing the Ubuntu OS."
} else {
    Write-Host "VM '$vm_name' does not appear to be running."
    Write-Host "Please check Hyper-V for any errors."
}
