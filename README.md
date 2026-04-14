# Linux Mint Cinnamon Power & Display Optimizer

I wrote this quick bash script to automatically manage my laptop's performance and display settings based on whether the charger is plugged in. 

## What it does
- **🔌 Plugged In:** Changes into `performance` mode, bumps the screen to 144Hz, and tweaks PipeWire for low-latency audio.
- **🔋 On Battery:** Drops to `power-saver` mode, lowers the screen to 60Hz to save juice, and relaxes audio settings.

## Quick Setup

1. Open `power_management.sh` and tweak the `USER_NAME` and `DISPLAY_NAME` variables for your setup.
2. Make it executable:
   `chmod +x power_management.sh`
3. Create a udev rule so it triggers automatically. Open or create `/etc/udev/rules.d/99-power.rules` and add this line:
   `SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ACTION=="change", RUN+="/path/to/your/power_management.sh"`
4. Reload udev to apply changes:
   `sudo udevadm control --reload-rules`
