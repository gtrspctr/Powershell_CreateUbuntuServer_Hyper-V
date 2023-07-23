# Powershell_CreateUbuntuServer_Hyper-V
Powershell script to quickly download and boot an Ubuntu server.

### Pre-Requisites
This script assumes the following is already in place:
1. Hyper-V is installed and your device is capable of hosting virtualized devices.
2. There is already a Virtual Switch created in Hyper-V.

### Customization
Lines 2-15 define the URL for the Ubuntu .iso download, the filepaths, and the VM settings.
Make sure you customize those however you'd like.

I recommend leaving the ```$generation``` and ```$secure_boot``` variables how they are unless you have specific reason to change them. For example, I don't think Ubuntu will even boot with the Secure Boot option enabled.
