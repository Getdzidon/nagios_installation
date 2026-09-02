#!/bin/bash

# This installs the NRPE plugin on your Nagios server
set -e

echo "=== Installing NRPE plugin on Nagios server ==="

# Update package index
sudo apt update

# Install the NRPE check plugin
sudo apt install -y nagios-nrpe-plugin

# Verify the plugin exists
PLUGIN="/usr/lib/nagios/plugins/check_nrpe"

if [ ! -f "$PLUGIN" ]; then
    echo "ERROR: check_nrpe plugin was not found."
    exit 1
fi

echo "check_nrpe found at: $PLUGIN"

# Create a symlink in the Nagios Core plugin directory
NAGIOS_PLUGIN_DIR="/usr/local/nagios/libexec"
TARGET="$NAGIOS_PLUGIN_DIR/check_nrpe"

if [ -L "$TARGET" ] || [ -f "$TARGET" ]; then
    echo "check_nrpe already exists in $NAGIOS_PLUGIN_DIR"
else
    sudo ln -s "$PLUGIN" "$TARGET"
    echo "Created symlink: $TARGET -> $PLUGIN"
fi

# Verify
echo
echo "=== Verification ==="
ls -l "$TARGET"

echo
echo "=== check_nrpe version ==="
"$TARGET" --version

echo
echo "=== Installation complete ==="
echo
echo "Next step: test against a monitored host:"
echo "$TARGET -H <CLIENT_IP>"


# /usr/local/nagios/libexec/check_nrpe -H 3.72.247.138 # Note 3.72.247.138 is the IP of the host we are checking
# /usr/local/nagios/libexec/check_nrpe -H 3.72.247.138 -c check_local_load # Note 3.72.247.138 is the IP of the host we are checking
