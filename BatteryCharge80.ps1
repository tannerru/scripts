# Check if the laptop supports battery threshold control
$battery_support = (Get-WmiObject -Class BatteryStatus).BatteryRechargeTime
# If the laptop does not support battery threshold control, exit the script
if ($battery_support -eq $null) {
    Write-Host "Battery threshold control is not supported on this device."
    exit
}
# Set the battery threshold level to 80%
$threshold_level = 80
# Calculate the threshold charge level in milliwatt-hours (mWh)
$threshold_charge = (Get-WmiObject -Class BatteryFullChargedCapacity).FullChargedCapacity * $threshold_level / 100
# Set the battery threshold
Set-WmiInstance -Namespace "root\wmi" -Class "BatteryStaticData" -Arguments @{StartControl=1; StopControl=1; SuggestedChargeThreshold=$threshold_charge}