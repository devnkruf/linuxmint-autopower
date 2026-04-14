#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
# Replace with your actual username
USER_NAME="user-name"

# Display settings (Run 'xrandr' in terminal to find your display name)
DISPLAY_NAME="eDP"
RESOLUTION="1920x1080"

# ==========================================
# SYSTEM VARIABLES (DO NOT CHANGE)
# ==========================================
# Required for udev to execute xrandr as the logged-in user
export DISPLAY=:0
export XAUTHORITY="/home/$USER_NAME/.Xauthority"

# Read AC adapter status (1 = Plugged in, 0 = Disconnected)
AC_STATUS=$(cat /sys/class/power_supply/AC*/online | head -n 1)

# ==========================================
# POWER PROFILES & SETTINGS
# ==========================================
if [ "$AC_STATUS" -eq 1 ]; then
    
    # 1. Set power mode to performance
    /usr/bin/powerprofilesctl set performance
    
    # 2. Set display to 144Hz
    /usr/bin/xrandr --output $DISPLAY_NAME --mode $RESOLUTION --rate 144.00
    
    # 3. Optimize PipeWire audio for performance (lower latency)
    sudo -u $USER_NAME XDG_RUNTIME_DIR=/run/user/$(id -u $USER_NAME) pw-metadata -n settings 0 clock.force-rate 48000
    sudo -u $USER_NAME XDG_RUNTIME_DIR=/run/user/$(id -u $USER_NAME) pw-metadata -n settings 0 clock.force-quantum 256

else
    
    # 1. Set power mode to power-saver
    /usr/bin/powerprofilesctl set power-saver
    
    # 2. Set display to 60Hz
    /usr/bin/xrandr --output $DISPLAY_NAME --mode $RESOLUTION --rate 60.00
    
    # 3. Optimize PipeWire audio for battery life
    sudo -u $USER_NAME XDG_RUNTIME_DIR=/run/user/$(id -u $USER_NAME) pw-metadata -n settings 0 clock.force-rate 48000
    sudo -u $USER_NAME XDG_RUNTIME_DIR=/run/user/$(id -u $USER_NAME) pw-metadata -n settings 0 clock.force-quantum 2048
fi
