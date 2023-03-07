# Disable Modern Standby on Windows PC
# Set the power mode to traditional standby
powercfg /SETACTIVE SCHEME_MIN
# Disable Modern Standby in the registry
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Power -Name PlatformAoAcOverride -Value 0
# Disable the Connected Standby feature in the registry
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Power\CsEnabled -Name CsEnabled -Value 0
# Reboot the PC for changes to take effect
Restart-Computer -Force