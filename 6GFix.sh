#!/bin/sh
###################################################################
# 6GHzFix.sh (6GHzFix)
#
# Original Creation Date: 2024-Aug-07 by @ExtremeFiretop.
# Last Modified: 2024-Aug-06
###################################################################

# Define a log file location
LOGFILE="/jffs/scripts/nvram_output.log"

# Log script start
echo "Starting 6GHz Fix" | tee "$LOGFILE"

echo "SLEEPING" | tee "$LOGFILE"
sleep 180

# Verify environment and permissions
echo "Current user: $(whoami)" | tee -a "$LOGFILE"
echo "Current directory: $(pwd)" | tee -a "$LOGFILE"
echo "Shell: $SHELL" | tee -a "$LOGFILE"

# Retrieve NVRAM variables matching the pattern wlc*_closed
wlc_closed_values=$(nvram show | grep -E '^wlc[0-9]*_closed=')
echo "Debug: Found wlc_closed_values: $wlc_closed_values" | tee -a "$LOGFILE"

# Process each wlc*_closed variable
set -f  # Disable filename expansion (globbing)
IFS="
"
for line in $wlc_closed_values; do
  # Check if line is not empty
  if [ -z "$line" ]; then
    echo "Warning: Empty line encountered in wlc_closed_values" | tee -a "$LOGFILE"
    continue
  fi

  # Extract the variable name
  var_name=$(echo "$line" | cut -d'=' -f1)
  echo "Debug: Processing var_name: $var_name" | tee -a "$LOGFILE"

  # Ensure the variable name is not empty
  if [ -z "$var_name" ]; then
    echo "Error: Failed to extract var_name from line: $line" | tee -a "$LOGFILE"
    continue
  fi

  # Set the NVRAM variable to 0
  if nvram set "$var_name=0"; then
    echo "Debug: Successfully set $var_name to 0" | tee -a "$LOGFILE"
  else
    echo "Error: Failed to set $var_name to 0" | tee -a "$LOGFILE"
    continue
  fi
done
unset IFS

# Find all NVRAM variables matching the pattern wlc*_ssid that contain "dwb"
wlc_ssid_values=$(nvram show | grep -E '^wlc[0-9]*_ssid=.*dwb')
echo "Debug: Found wlc_ssid_values: $wlc_ssid_values" | tee -a "$LOGFILE"

# Initialize wl_ssid_value
wl_ssid_value=""

# Process each wlc*_ssid variable
set -f  # Disable filename expansion (globbing)
IFS="
"
for line in $wlc_ssid_values; do
  # Check if line is not empty
  if [ -z "$line" ]; then
    echo "Warning: Empty line encountered in wlc_ssid_values" | tee -a "$LOGFILE"
    continue
  fi

  # Extract the variable name
  var_name=$(echo "$line" | cut -d'=' -f1)
  echo "Debug: Processing var_name: $var_name" | tee -a "$LOGFILE"

  # Ensure the variable name is not empty
  if [ -z "$var_name" ]; then
    echo "Error: Failed to extract var_name from line: $line" | tee -a "$LOGFILE"
    continue
  fi

  # Extract the current value
  current_value=$(echo "$line" | cut -d'=' -f2-)
  echo "Debug: Current value of $var_name: $current_value" | tee -a "$LOGFILE"

  # Remove '_dwb' from the value
  new_value=$(echo "$current_value" | sed 's/_dwb//g')
  echo "Debug: Value after removing '_dwb': $new_value" | tee -a "$LOGFILE"

  # Replace "2.4GHz" or "5GHz" with "6GHz", case-insensitive
  new_value=$(echo "$new_value" | sed -E 's/(2\.4|5)GHz/6GHz/I')
  echo "Debug: Value after replacing with 6GHz: $new_value" | tee -a "$LOGFILE"

  # Append the new value to the wl_ssid_value variable
  wl_ssid_value="${wl_ssid_value}${new_value}"
  echo "Debug: wl_ssid_value updated to: $wl_ssid_value" | tee -a "$LOGFILE"
done
unset IFS

# Set final NVRAM variables
if nvram set wl2.1_closed=0; then
  echo "Debug: Set wl2.1_closed to 0" | tee -a "$LOGFILE"
else
  echo "Error: Failed to set wl2.1_closed to 0" | tee -a "$LOGFILE"
fi

if nvram set wl2.1_ssid="$wl_ssid_value"; then
  echo "Debug: Set wl2.1_ssid to $wl_ssid_value" | tee -a "$LOGFILE"
else
  echo "Error: Failed to set wl2.1_ssid to $wl_ssid_value" | tee -a "$LOGFILE"
fi

# Commit changes to NVRAM
sleep 3
if nvram commit; then
  echo "Debug: NVRAM committed" | tee -a "$LOGFILE"
else
  echo "Error: Failed to commit NVRAM" | tee -a "$LOGFILE"
fi

# Turn on the radio and set up the interface
sleep 3
if wl -i wl2.1 ssid "$wl_ssid_value" >/dev/null 2>&1; then
  echo "Debug: Wireless interface wl2.1 ssid set to $wl_ssid_value" | tee -a "$LOGFILE"
else
  echo "Error: Failed to set wireless interface wl2.1 ssid to $wl_ssid_value" | tee -a "$LOGFILE"
fi

# Restart wireless service
sleep 10
if service restart_wireless >/dev/null 2>&1; then
  echo "Debug: Wireless service restarted" | tee -a "$LOGFILE"
else
  echo "Error: Failed to restart wireless service" | tee -a "$LOGFILE"
fi

sleep 10
echo "6GHz Fix Done" | tee -a "$LOGFILE"

exit 0


#EOF#
