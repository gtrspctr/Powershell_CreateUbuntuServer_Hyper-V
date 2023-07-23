# Define Ubuntu .iso URL and outfile
$iso_url = "https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-live-server-amd64.iso"
$iso_outfile = "C:\HYPER-V\ubuntu-22.04.2-live-server-amd64.iso"

# Local paths for VM
$vm_name = "ubuntu_web"
$vm_path = "C:\HYPER-V\ubuntu_web"
$vhd_path = "C:\HYPER-V\ubuntu_web\ubuntu_web.vhdx"
$switch_name = "New Virtual Switch"

# VM settings
$memory_size = 2GB
$vhd_size = 20GB
$generation = 2
$secure_boot = Off

# Download ubuntu installer
$ProgressPreference = "SilentlyContinue"  # Disables progress bar, speeding up download
if (!(Test-Path -Path $iso_outfile)) {
    Invoke-WebRequest -Uri $iso_url -Outfile $iso_outfile
}

# Create VM
New-VM -Name $vm_name `
-MemoryStartupBytes $memory_size `
-Path $vm_path `
-NewVHDPath $vhd_path `
-NewVHDSizeBytes $vhd_size `
-Generation $generation `
-SwitchName $switch_name  `
-Force

# Mount iso
Add-VMDvdDrive -VMName $vm_name `
-Path $iso_outfile

# Set VM firmware options
Set-VMFirmware -VMName $vm_name `
-EnableSecureBoot $secure_boot `
-BootOrder $(Get-VMDvdDrive -VMName $vm_name),
           $(Get-VMHardDiskDrive -VMName $vm_name),
           $(Get-VMNetworkAdapter -VMName $vm_name)

# Start VM
Start-VM -VMName $vm_name