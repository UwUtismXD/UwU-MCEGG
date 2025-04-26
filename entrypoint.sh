#!/bin/bash

CONFIG_DIR="/home/container"
CONFIG_FILE="$CONFIG_DIR/settings.env"

mkdir -p "$CONFIG_DIR"

if [ -f "$CONFIG_FILE" ]; then
  echo "Loading saved settings from $CONFIG_FILE"
  source "$CONFIG_FILE"
else
  echo "Select Minecraft edition:"
  echo "1) bedrock"
  echo "2) java"
  echo "3) proxy"
  echo -n "Enter choice [1-3] (default: 2): "
  read edition_choice

  case "$edition_choice" in
    1) EDITION="bedrock" ;;
    3) EDITION="proxy" ;;
    *) EDITION="java" ;;
  esac

  if [ "$EDITION" = "bedrock" ]; then
    echo "Select Bedrock server software:"
    echo "1) vanilla"
    echo -n "Enter choice [1] (default: 1): "
    read bedrock_choice
    case "$bedrock_choice" in
      1) SERVER_SOFTWARE="bedrock-vanilla" ;;
      *) SERVER_SOFTWARE="bedrock-vanilla" ;;
    esac

  elif [ "$EDITION" = "java" ]; then
    echo "Select Java server software:"
    echo "1) vanilla"
    echo "2) paper"
    echo "3) purpur"
    echo "4) forge"
    echo "5) neoforge"
    echo "6) fabric"
    echo -n "Enter choice [1-6] (default: 1): "
    read java_choice
    case "$java_choice" in
      2) SERVER_SOFTWARE="papermc" ;;
      3) SERVER_SOFTWARE="purpur" ;;
      4) SERVER_SOFTWARE="forge" ;;
      5) SERVER_SOFTWARE="neoforge" ;;
      6) SERVER_SOFTWARE="fabric" ;;
      *) SERVER_SOFTWARE="vanilla" ;;
    esac

  elif [ "$EDITION" = "proxy" ]; then
    echo "Select Proxy server software:"
    echo "1) velocity"
    echo "2) bungeecord"
    echo -n "Enter choice [1-2] (default: 1): "
    read proxy_choice
    case "$proxy_choice" in
      2) SERVER_SOFTWARE="bungeecord" ;;
      *) SERVER_SOFTWARE="velocity" ;;
    esac
  fi

  echo -n "Enter Minecraft server version to run (default: latest): "
  read input_version

  if [ -z "$input_version" ]; then
    MINECRAFT_VERSION="latest"
  else
    MINECRAFT_VERSION="$input_version"
  fi

  # Save settings to config file
  echo "EDITION=$EDITION" > "$CONFIG_FILE"
  echo "SERVER_SOFTWARE=$SERVER_SOFTWARE" >> "$CONFIG_FILE"
  echo "MINECRAFT_VERSION=$MINECRAFT_VERSION" >> "$CONFIG_FILE"
fi

export EDITION
export SERVER_SOFTWARE
export MINECRAFT_VERSION

# Run the server start script
exec /t.sh "$@"