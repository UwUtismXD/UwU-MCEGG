#!/bin/bash

# Prompt user for Minecraft server software
echo "Select Minecraft server software:"
echo "1) vanilla"
echo "2) purpur"
echo "3) papermc"
read -p "Enter choice [1-3] (default: 1): " software_choice

case "$software_choice" in
  2) export SERVER_SOFTWARE="purpur" ;;
  3) export SERVER_SOFTWARE="papermc" ;;
  *) export SERVER_SOFTWARE="vanilla" ;;
esac

# Prompt user for Minecraft server version
read -p "Enter Minecraft server version to run (default: latest): " input_version

if [ -z "$input_version" ]; then
  export MINECRAFT_VERSION="latest"
else
  export MINECRAFT_VERSION="$input_version"
fi

# Run the server start script
exec ./t.sh