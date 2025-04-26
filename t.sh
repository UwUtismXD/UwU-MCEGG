#!/bin/bash

# This script runs the Minecraft server with the selected version and Java options

# Set default values if not set
MINECRAFT_VERSION="${MINECRAFT_VERSION:-latest}"
JAVA_VERSION="${JAVA_VERSION:-21}"
JAVA_ARGS="${JAVA_ARGS:--Xms1G -Xmx2G}"
SERVER_SOFTWARE="${SERVER_SOFTWARE:-vanilla}"

echo "Starting Minecraft server version: $MINECRAFT_VERSION"
echo "Using Java version: $JAVA_VERSION"
echo "Java arguments: $JAVA_ARGS"
echo "Server software: $SERVER_SOFTWARE"

SERVER_JAR="server.jar"

if [ "$SERVER_SOFTWARE" = "vanilla" ]; then
  # Vanilla Minecraft server download logic
  VERSION_MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"
  VERSION_MANIFEST_JSON=$(curl -s "$VERSION_MANIFEST_URL")

  if [ "$MINECRAFT_VERSION" = "latest" ]; then
    MINECRAFT_VERSION=$(echo "$VERSION_MANIFEST_JSON" | jq -r '.latest.release')
  fi

  VERSION_URL=$(echo "$VERSION_MANIFEST_JSON" | jq -r --arg ver "$MINECRAFT_VERSION" '.versions[] | select(.id == $ver) | .url')

  if [ -z "$VERSION_URL" ] || [ "$VERSION_URL" == "null" ]; then
    echo "Failed to find metadata URL for version $MINECRAFT_VERSION. Exiting."
    exit 1
  fi

  echo "Fetching version metadata from $VERSION_URL"
  VERSION_JSON=$(curl -s "$VERSION_URL")

  SERVER_JAR_URL=$(echo "$VERSION_JSON" | jq -r '.downloads.server.url')

  if [ -z "$SERVER_JAR_URL" ] || [ "$SERVER_JAR_URL" == "null" ]; then
    echo "Failed to find server jar URL in version metadata. Exiting."
    exit 1
  fi

elif [ "$SERVER_SOFTWARE" = "purpur" ]; then
  # Purpur server download logic
  if [ "$MINECRAFT_VERSION" = "latest" ]; then
    # Get latest Purpur version from API
    MINECRAFT_VERSION=$(curl -s https://api.purpurmc.org/v2/purpur | jq -r '.versions[-1]')
  fi

  echo "Fetching latest Purpur build for version $MINECRAFT_VERSION"
  BUILD=$(curl -s "https://api.purpurmc.org/v2/purpur/$MINECRAFT_VERSION/latest" | jq -r '.build')

  if [ -z "$BUILD" ] || [ "$BUILD" == "null" ]; then
    echo "Failed to find latest Purpur build for version $MINECRAFT_VERSION. Exiting."
    exit 1
  fi

  SERVER_JAR_URL="https://api.purpurmc.org/v2/purpur/$MINECRAFT_VERSION/$BUILD/download"

elif [ "$SERVER_SOFTWARE" = "papermc" ]; then
  # PaperMC server download logic
  if [ "$MINECRAFT_VERSION" = "latest" ]; then
    # Get latest PaperMC version from API
    MINECRAFT_VERSION=$(curl -s https://papermc.io/api/v2/projects/paper | jq -r '.versions[-1]')
  fi

  echo "Fetching latest PaperMC build for version $MINECRAFT_VERSION"
  BUILD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$MINECRAFT_VERSION" | jq -r '.builds[-1]')

  if [ -z "$BUILD" ] || [ "$BUILD" == "null" ]; then
    echo "Failed to find latest PaperMC build for version $MINECRAFT_VERSION. Exiting."
    exit 1
  fi

  SERVER_JAR_URL="https://papermc.io/api/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$BUILD/downloads/paper-$MINECRAFT_VERSION-$BUILD.jar"

else
  echo "Unknown server software: $SERVER_SOFTWARE. Exiting."
  exit 1
fi

echo "Downloading server jar from $SERVER_JAR_URL"
curl -o "$SERVER_JAR" "$SERVER_JAR_URL"

# Accept EULA
echo "eula=true" > eula.txt

# Run the server with the specified Java version and arguments
exec java $JAVA_ARGS -jar "$SERVER_JAR" nogui