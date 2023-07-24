# Powershell_CreateUbuntuServer_Hyper-V
Powershell_CreateUbuntuServer_Hyper-V is a PowerShell script that allows you to quickly download and boot an Ubuntu server in Hyper-V on Windows.

## Description
This PowerShell script automates the process of downloading the latest Ubuntu server ISO and creating a virtual machine (VM) in Hyper-V with the specified configuration. It's designed to streamline the setup of an Ubuntu server VM, making it easy to get started with Ubuntu on Hyper-V.

## Pre-Requisites
Before running the script, ensure you have the following pre-requisites:
1. **Hyper-V installed and running:** The script relies on Hyper-V to create and manage the virtual machine. Ensure that Hyper-V is installed and enabled on your Windows machine.
2. **Virtual Switch created:** A virtual switch must be created in Hyper-V. This is essentially a NIC for the virtual machine to use for networking.
3. **PowerShell with elevated privileges:** Run the PowerShell script as an administrator to ensure it has the necessary permissions to create VMs and directories.

## Customizing URL, Paths, and VM Options
To customize the script for your needs, you can modify the following variables:
1. **$iso_url:** The URL of the Ubuntu server ISO. By default, it points to the latest release, but you can change it if you need a specific version.
2. **$iso_outfile:** The local path where the Ubuntu ISO will be downloaded. By default, it's set to "C:\HYPER-V\ubuntu-22.04.2-live-server-amd64.iso".
3. **$vm_name:** The name of the virtual machine that will be created. By default, it's set to "ubuntu".
4. **$vm_path:** The local path where the VM files will be stored. By default, it's set to "C:\HYPER-V\\$vm_name".
5. **$vhd_path:** The local path where the VHD (Virtual Hard Disk) of the VM will be stored. By default, it's set to "$vm_path\\$vm_name.vhdx".

**Note:** It's recommended to keep the ```$secure_boot``` variable unchanged unless you have specific reason to modify it. Ubuntu will not boot in Hyper-V with Secure Boot enabled.

## Usage
1. Clone or download this repository to your local machine, or simply download or copy/paste 'Create-Ubuntu-VM.ps1' and save it to your local computer.
2. Open a PowerShell console with elevated privileges (Run as Administrator).
3. Navigate to the directory containing the script.
4. Customize the URL, paths, and VM options as needed (if necessary).
5. Run the script using the following command:  ```.\Create-Ubuntu-VM.ps1```
6. Monitor the script's progress in the console.
7. Once the VM is created and booted, continue with the Ubuntu installation process inside the VM.

## Contributing
Feel free to contribute to this script by opening issues or pull requests. Your feedback and contributions are welcome!

## License
This script is open-source and available under the [MIT License](LICENSE).
Enjoy your new Ubuntu server on Hyper-V!
